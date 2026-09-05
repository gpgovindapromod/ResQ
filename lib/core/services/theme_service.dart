import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  ThemeService._privateConstructor();
  static final ThemeService instance = ThemeService._privateConstructor();

  static const String _themePrefKey = 'user_theme_mode';

  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePrefKey);
      if (savedTheme == 'dark') {
        themeModeNotifier.value = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        themeModeNotifier.value = ThemeMode.light;
      } else {
        themeModeNotifier.value = ThemeMode.system;
      }
    } catch (_) {
      themeModeNotifier.value = ThemeMode.light;
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    themeModeNotifier.value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, isDark ? 'dark' : 'light');
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      String val = 'system';
      if (mode == ThemeMode.dark) val = 'dark';
      if (mode == ThemeMode.light) val = 'light';
      await prefs.setString(_themePrefKey, val);
    } catch (_) {}
  }
}
