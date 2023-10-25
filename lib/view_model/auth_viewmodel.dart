import 'dart:async';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:etravel_mobile/main.dart';
import 'package:etravel_mobile/services/callkit_service.dart';
import 'package:etravel_mobile/view_model/profile_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/app_exception.dart';
import '../main_app.dart';
import '../models/account.dart';
import '../models/language.dart';
import '../res/app_url.dart';
import '../services/local_storage_service.dart';
import '../services/logger_service.dart';
import '../services/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import '../view/auth/choose_language_dialog.dart';
import '../view/auth/error_alert_dialog.dart';
import 'language_viewmodel.dart';
import 'main_app_viewmodel.dart';

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();
  IO.Socket _socket = IO.io(
    AppUrl.socketBaseUrl,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );

  IO.Socket get socket =>
      _socket.connected ? _socket : throw Exception('Not connected');

  connectSocket() {
    if (_socket.connected) {
      return;
    }
    _socket = _socket.connect();
  }

  disconnectSocket() {
    if (!_socket.connected) {
      return;
    }

    _socket = _socket.close();
  }

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> autoLogin(BuildContext ctx) async {
    final existingToken =
        await SecureStorageService.getInstance.readSecureAccessToken();
    if (existingToken == null) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    final expiredTimePref = prefs.getString('expiredTime');
    if (expiredTimePref == null) {
      return false;
    }
    final expiredTime = DateTime.parse(expiredTimePref);
    final now = DateTime.now();
    if (expiredTime.difference(now).isNegative) {
      return false;
    }
    final existingAccountData =
        await LocalStorageService.getInstance.getAccount();
    if (existingAccountData == null) {
      return false;
    }
    bool isLoggedInExternal = false;
    if (ctx.mounted) {
      isLoggedInExternal =
          await _checkIsLoggedInExternal(existingAccountData, ctx);
    }
    if (!isLoggedInExternal) {
      return false;
    }
    return true;
  }

  Future<bool> _checkIsLoggedInExternal(
      Account account, BuildContext ctx) async {
    try {
      final isLoggedIn = await ChatClient.getInstance.isLoginBefore();
      if (!isLoggedIn) {
        return false;
      }
      final isSubmitSocketSuccess = await _submitToSocket(account);
      if (!isSubmitSocketSuccess) {
        return false;
      }
      bool isFirebaseLogin = FirebaseAuth.instance.currentUser != null;
      if (isFirebaseLogin) {
        await FirebaseAuth.instance.signOut();
      }
      StreamSubscription? agoraStreamSub;
      if (!ctx.mounted) {
        // Don't care
      } else {
        agoraStreamSub = Provider.of<ProfileViewModel>(ctx, listen: false)
            .streamSubscription;
        await agoraStreamSub?.cancel();
        agoraStreamSub = await CallkitService().initializeCallkit(navigatorKey);
      }
      return true;
    } on ChatError catch (chatEx) {
      if (chatEx.code == 200) {
        return true;
      }
      return false;
    }
  }

  Future<bool> _submitToSocket(Account account) async {
    try {
      final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      connectSocket();
      final socketData = {
        'id': account.id,
        'firstName': account.firstName,
        'lastName': account.lastName,
        'image': account.image,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'languageCode': account.languageCode,
      };
      _socket.emit('online', socketData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> login(
    Map<String, dynamic> data,
    BuildContext context,
    TextEditingController phoneEdit,
    TextEditingController passwordEdit,
  ) async {
    String? deviceToken;
    setLoading(true);
    await SecureStorageService.getInstance
        .readSecureFCMToken()
        .then(
          (value) => deviceToken = value,
        )
        .onError((error, stackTrace) {
      if (kDebugMode) {
        if (error is NotFoundDeviceTokenException) {}
      }
      return null;
    });
    data.addAll(<String, String>{'deviceToken': deviceToken!});
    _authRepo.loginApi(data).then((authData) {
      final account = Account.fromJson(authData['account']);
      return SecureStorageService.getInstance
          .writeSecureAcessToken(account.accessToken!)
          .then((value) => Future.value(account));
    }).then((account) async {
      final currentAppLanguage =
          Provider.of<MainAppViewModel>(context, listen: false);
      if (account.languageCode != currentAppLanguage.code) {
        var languages =
            Provider.of<LanguageViewModel>(context, listen: false).languages;
        setLoading(false);

        var selectedLanguage = await showDialog<Language>(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            final accountLanguage = languages.firstWhere(
                (element) => element.languageCode == account.languageCode);
            final appLanguage = languages.firstWhere(
                (element) => element.languageCode == currentAppLanguage.code);
            return ChooseLanguageDialog(
              accountLanguage: accountLanguage,
              appLanguage: appLanguage,
            );
          },
        );
        setLoading(true);

        if (selectedLanguage!.languageCode != account.languageCode) {
          var newTokenData =
              await _authRepo.changeLanguageApi(selectedLanguage.id!);
          account.accessToken = newTokenData['account']['accessToken'];
          account.languageId = selectedLanguage.id!;
          account.languageCode = selectedLanguage.languageCode!;
        }
      }
      await LocalStorageService.getInstance
          .saveLanguageCode(account.languageCode!);
      await LocalStorageService.getInstance.saveAccountInfo(account);
      var accessToken = account.accessToken ?? 'No access token';
      try {
        await ChatClient.getInstance
            .logout(); // Logout to make sure no one stucks
        await ChatClient.getInstance.login(
          account.email!.split('@')[0],
          data['password'],
        );
      } on ChatError catch (chatErr) {
        if (chatErr.code != 200) {
          throw AppException(['Cannot login to Agora.']);
        }
      }
      final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      connectSocket();
      final socketData = {
        'id': account.id,
        'firstName': account.firstName,
        'lastName': account.lastName,
        'image': account.image,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'languageCode': account.languageCode,
      };
      _socket.emit('online', socketData);
      CallkitService().initializeCallkit(navigatorKey);
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now()
          .add(const Duration(
            days: 365, //* Get real time instead of hardcode 365 days
          ))
          .toIso8601String();
      await prefs.setString('expiredTime', now);
      await SecureStorageService.getInstance
          .writeSecureAcessToken(accessToken)
          .then((value) {
        setLoading(false);

        return Provider.of<MainAppViewModel>(context, listen: false)
            .changeLanguage(
                context, account.languageId!, account.languageCode!);
      }).then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const MainApp(),
          ),
          (route) => false,
        );
        phoneEdit.clear();
        passwordEdit.clear();
        loggerInfo.i('Login successfully!');
      });
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        if (error is BadRequestException) {
          loggerInfo.e('Login fail!');
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => ErrorAlertDialog(
              error: error,
            ),
          );
        }
      }
    });
  }

  Future<void> registerApi(dynamic data, String accessToken) async {
    setLoading(true);

    _authRepo.registerApi(data).then((value) {
      setLoading(false);
      if (kDebugMode) {
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      //Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
