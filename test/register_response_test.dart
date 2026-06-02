import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/features/auth/data/models/register_response.dart';

void main() {
  group('RegisterResponse.fromJson', () {
    test('reads access_token from data wrapper', () {
      final response = RegisterResponse.fromJson({
        'data': {
          'access_token': 'reg-token',
          'user': {'id': 2},
        },
      });

      expect(response.accessToken, 'reg-token');
      expect(response.user, isNotNull);
    });

    test('reads login_token from root payload', () {
      final response = RegisterResponse.fromJson({
        'login_token': 'legacy-token',
      });

      expect(response.accessToken, 'legacy-token');
    });

    test('throws when token is missing', () {
      expect(
        () => RegisterResponse.fromJson({'message': 'ok'}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
