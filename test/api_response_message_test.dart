import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/core/error/api_response_message.dart';

void main() {
  group('formatApiErrorForUser', () {
    test('reads specific top-level message when no errors map', () {
      expect(
        formatApiErrorForUser({'message': 'Promo code is invalid.'}),
        'Promo code is invalid.',
      );
    });

    test('reads errors map when message is absent', () {
      expect(
        formatApiErrorForUser({
          'errors': {
            'vehicle_number': ['The vehicle number field is required.'],
          },
        }),
        'The vehicle number field is required.',
      );
    });

    test('prefers field errors over generic Validation error on signup', () {
      expect(
        formatApiErrorForUser({
          'success': false,
          'message': 'Validation error',
          'errors': {
            'email': ['The email has already been taken.'],
            'phone': ['The phone has already been taken.'],
          },
        }),
        'The email has already been taken. · The phone has already been taken.',
      );
    });

    test('joins multiple field errors with separator for compact toast', () {
      final message = formatApiErrorForUser({
        'message': 'The given data was invalid.',
        'errors': {
          'email': ['Enter a valid email address.'],
          'password': ['The password field is required.'],
        },
      });
      expect(message, contains(' · '));
      expect(message, contains('Enter a valid email address.'));
      expect(message, contains('The password field is required.'));
    });

    test('uses headline when it is specific even with errors map', () {
      expect(
        formatApiErrorForUser({
          'message': 'This promo code has expired.',
          'errors': {'code': ['Invalid promo code.']},
        }),
        'This promo code has expired.',
      );
    });

    test('reads string body', () {
      expect(formatApiErrorForUser('Not Found'), 'Not Found');
    });
  });
}
