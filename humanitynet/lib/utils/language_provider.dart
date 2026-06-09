import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isUrdu => _locale.languageCode == 'ur';
  bool get isEnglish => _locale.languageCode == 'en';

  LanguageProvider() {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language') ?? 'en';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setEnglish() async {
    _locale = const Locale('en');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', 'en');
    notifyListeners();
  }

  Future<void> setUrdu() async {
    _locale = const Locale('ur');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', 'ur');
    notifyListeners();
  }

  Future<void> toggle() async {
    if (isEnglish) {
      await setUrdu();
    } else {
      await setEnglish();
    }
  }
}