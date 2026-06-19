import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsRepository {
  static const String _languageCodeKey = 'language_code';
  static const String _themeModeKey = 'theme_mode';

  Future<String?> getSavedLanguageCode() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(_languageCodeKey);
  }

  Future<void> saveLanguageCode(String languageCode) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(_languageCodeKey, languageCode);
  }

  Future<ThemeMode> getSavedThemeMode() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final themeModeName = sharedPreferences.getString(_themeModeKey);

    switch (themeModeName) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_themeModeKey, themeMode.name);
  }
}
