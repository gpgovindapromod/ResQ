import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  LanguageService._();
  static final LanguageService instance = LanguageService._();

  static const String _prefKey = 'selected_language_code';

  final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(const Locale('en'));

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_prefKey) ?? 'en';
    localeNotifier.value = Locale(savedCode);
  }

  Future<void> setLanguage(String languageCode) async {
    localeNotifier.value = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, languageCode);
  }

  String get currentLanguageCode => localeNotifier.value.languageCode;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
  ];
}
