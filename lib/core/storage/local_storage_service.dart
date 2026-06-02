import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  const LocalStorageService(this._prefs);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const _rememberMeEnabledKey = 'remember_me_enabled';
  static const _rememberedLoginKey = 'remembered_login';
  static const _rememberedPasswordKey = 'remembered_password';

  final SharedPreferences _prefs;

  Future<String?> readAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  Future<String?> readRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  Future<bool> hasSeenOnboarding() async {
    return _prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(_hasSeenOnboardingKey, true);
  }

  Future<bool> isRememberMeEnabled() async {
    return _prefs.getBool(_rememberMeEnabledKey) ?? false;
  }

  Future<String?> readRememberedLogin() async {
    return _prefs.getString(_rememberedLoginKey);
  }

  Future<String?> readRememberedPassword() async {
    return _prefs.getString(_rememberedPasswordKey);
  }

  Future<void> saveRememberMe({
    required String login,
    required String password,
  }) async {
    await _prefs.setBool(_rememberMeEnabledKey, true);
    await _prefs.setString(_rememberedLoginKey, login);
    await _prefs.setString(_rememberedPasswordKey, password);
  }

  Future<void> clearRememberMe() async {
    await _prefs.setBool(_rememberMeEnabledKey, false);
    await _prefs.remove(_rememberedLoginKey);
    await _prefs.remove(_rememberedPasswordKey);
  }
}
