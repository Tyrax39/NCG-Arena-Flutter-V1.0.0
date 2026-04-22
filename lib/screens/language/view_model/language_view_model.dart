import 'package:neoncave_arena/screens/language/model/language_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageViewModel extends ChangeNotifier {
  void disposeValues() {}
  Locale? _appLocale;
  int _selectedLanguageIndex = 0;

  Locale? get appLocale => _appLocale;
  int get selectedLanguageIndex => _selectedLanguageIndex;

  LanguageViewModel() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? languageCode = sp.getString('language_code');
    if (languageCode != null) {
      _appLocale = Locale(languageCode);
      _selectedLanguageIndex =
          languageList.indexWhere((language) => language.code == languageCode);
    } else {
      _appLocale = const Locale('en'); // Default locale
    }
    notifyListeners();
  }

  Future<void> saveLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('language_code', type.languageCode);

    // Update the selected language index
    _selectedLanguageIndex = languageList
        .indexWhere((language) => language.code == type.languageCode);

    _appLocale = type;
    notifyListeners();
  }
}
