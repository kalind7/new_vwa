import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/features/auth/presentation/utils/auth_form_validators.dart';

void main() {
  group('Nepali plate validation', () {
    test('accepts spaced plate', () {
      expect(AuthFormValidators.isValidNepaliPlate('Ba Pa 2446'), isTrue);
    });

    test('accepts hyphenated plate', () {
      expect(AuthFormValidators.isValidNepaliPlate('Ba-pa-1097'), isTrue);
    });

    test('rejects numbers only', () {
      expect(AuthFormValidators.isValidNepaliPlate('2446'), isFalse);
    });

    test('rejects letters only', () {
      expect(AuthFormValidators.isValidNepaliPlate('Ba Pa'), isFalse);
    });
  });
}
