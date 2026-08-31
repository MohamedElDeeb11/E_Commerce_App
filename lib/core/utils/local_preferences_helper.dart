import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferencesHelper {
  final SharedPreferences _prefs;

  LocalPreferencesHelper(this._prefs);

  static const String _kHasSeenOnboarding = 'has_seen_onboarding';
  static const String _kAuthToken = 'auth_token';
  static const String _kIsDarkMode = 'is_dark_mode';

  bool get hasSeenOnboarding => _prefs.getBool(_kHasSeenOnboarding) ?? false;
  Future<bool> setHasSeenOnboarding(bool value) async =>
      await _prefs.setBool(_kHasSeenOnboarding, value);

  String? get authToken => _prefs.getString(_kAuthToken);
  Future<bool> setAuthToken(String token) async =>
      await _prefs.setString(_kAuthToken, token);
  Future<bool> clearAuthToken() async => await _prefs.remove(_kAuthToken);

  bool get isDarkMode => _prefs.getBool(_kIsDarkMode) ?? false;
  Future<bool> setDarkMode(bool value) async =>
      await _prefs.setBool(_kIsDarkMode, value);
}
