import 'dart:async';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:etravel_mobile/services/callkit_service.dart';
import 'package:etravel_mobile/view/auth/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import '../services/local_storage_service.dart';
import '../services/secure_storage_service.dart';
import 'package:flutter/material.dart';

class ProfileViewModel with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  StreamSubscription<CallEvent?>? streamSubscription;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future logout(BuildContext profileViewContext) async {
    if (streamSubscription != null) {
      CallkitService().closeCallkit(streamSubscription!);
    }
    await FirebaseAuth.instance.signOut();
    await SecureStorageService.getInstance.clearAccessToken();
    await ChatClient.getInstance.logout();
    await LocalStorageService.getInstance.removeAccountData().then(
          (value) => Navigator.pushAndRemoveUntil(
            profileViewContext,
            MaterialPageRoute(
              builder: (_) => const LoginView(),
            ),
            (route) => false,
          ),
        );
  }
}
