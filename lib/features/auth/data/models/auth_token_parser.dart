class AuthTokenParser {
  const AuthTokenParser._();

  static String readAccessToken(Map<String, dynamic> payload) {
    for (final key in ['access_token', 'token', 'login_token']) {
      final value = payload[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    throw const FormatException('Missing token in auth response');
  }
}
