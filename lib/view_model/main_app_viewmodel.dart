import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class MainAppViewModel extends ChangeNotifier {
  int id;
  String code;
  bool isLoading = false;
  MainAppViewModel({
    required this.id,
    required this.code,
  });

  Future<void> changeLanguage(BuildContext ctx, int id, String languageCode) {
    final newLocale = Utils.getLanguageCodeToLocalize(languageCode);
    return ctx.setLocale(newLocale).then((value) {
      this.id = id;
      code = languageCode;
      notifyListeners();
    });
  }
}
