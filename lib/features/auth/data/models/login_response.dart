import 'auth_token_parser.dart';

class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    this.refreshToken,
    this.user,
  });

  final String accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final token = AuthTokenParser.readAccessToken(payload);
    final refreshToken =
        payload['refresh_token'] as String? ??
        payload['refreshToken'] as String?;

    final user = payload['user'];
    return LoginResponse(
      accessToken: token,
      refreshToken: refreshToken,
      user: user is Map<String, dynamic> ? user : null,
    );
  }
}
