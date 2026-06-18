import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsRepository {
  static const String _languageCodeKey = 'language_code';

  Future<String?> getSavedLanguageCode() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(_languageCodeKey);
  }

  Future<void> saveLanguageCode(String languageCode) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(_languageCodeKey, languageCode);
  }
}
