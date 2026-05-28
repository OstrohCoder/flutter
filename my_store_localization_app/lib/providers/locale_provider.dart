import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _languageCodeKey = 'language_code';
  Locale _locale = const Locale('uk');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
    debugPrint('✅ Language saved: ${locale.languageCode}');
  }

  Future<void> resetLocale() async {
    _locale = const Locale('uk');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageCodeKey);
  }
}
