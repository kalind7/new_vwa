import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/features/auth/data/models/login_response.dart';

void main() {
  group('LoginResponse.fromJson', () {
    test('reads access_token from data wrapper', () {
      final response = LoginResponse.fromJson({
        'data': {
          'access_token': 'abc123',
          'user': {'id': 1},
        },
      });

      expect(response.accessToken, 'abc123');
      expect(response.user, isNotNull);
    });

    test('reads token from root payload', () {
      final response = LoginResponse.fromJson({'token': 'xyz'});

      expect(response.accessToken, 'xyz');
    });

    test('throws when token is missing', () {
      expect(
        () => LoginResponse.fromJson({'message': 'ok'}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
