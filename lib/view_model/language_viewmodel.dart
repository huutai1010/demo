import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../models/language.dart';
import '../repository/language_repository.dart';
import 'package:flutter/foundation.dart';

import '../services/logger_service.dart';

class LanguageViewModel extends ChangeNotifier {
  List<Language> languages = [];
  final _languageRepo = LanguageRepository();

  Future getLanguages() async {
    try {
      final response = await _languageRepo
          .getLanguages()
          .then((value) => value['languages']) as List;
      languages = response.map((e) => Language.fromJson(e)).toList();
      if (languages.isNotEmpty) {
        final modelManager = OnDeviceTranslatorModelManager();
        Future.wait(languages.map((e) async {
          final languageCode = e.languageCode!.split('-')[0].toLowerCase();
          await modelManager.downloadModel(languageCode);
        }));
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        loggerInfo.e(error.toString());
      }
    }
  }
}
