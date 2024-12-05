import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class LanguageConfig {
  static final translator = GoogleTranslator();

  static Future<String> getSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedLanguage') ?? 'en';
  }

  static Future<void> saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', lang);
  }

  static Future<Map<String, String>> translateTexts(
      Map<String, String> texts, String lang) async {
    Map<String, String> translations = {};
    for (var entry in texts.entries) {
      translations[entry.key] =
          (await translator.translate(entry.value, to: lang)).text;
    }
    return translations;
  }
}

class LanguageNotifier extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('selectedLanguage') ?? 'en';
    notifyListeners();
  }

  Future<void> changeLanguage(String newLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLanguage = newLanguage;
    await prefs.setString('selectedLanguage', newLanguage);
    notifyListeners();
  }
}