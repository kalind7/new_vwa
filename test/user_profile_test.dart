import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vwa/features/profile/data/models/user_profile.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: 'assets/env/.env');
  });

  group('UserProfile.fromJson', () {
    test('parses auth/me payload with vehicles', () {
      final profile = UserProfile.fromJson({
        'success': true,
        'data': {
          'id': 8,
          'name': 'New Name3',
          'email': 'user@example.com',
          'phone': '9845656562',
          'avatar': '/img/default-avatar.jpg',
          'vehicles': [
            {
              'id': 1,
              'vehicle_number': 'BA PA 2446',
              'vehicle_type': 'bike',
              'is_default': true,
            },
          ],
        },
      });

      expect(profile.id, 8);
      expect(profile.displayName, 'New Name3');
      expect(profile.phone, '9845656562');
      expect(profile.vehicles, hasLength(1));
      expect(profile.avatarUrl, contains('default-avatar.jpg'));
    });
  });
}
