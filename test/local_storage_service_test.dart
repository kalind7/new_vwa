import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vwa/core/storage/local_storage_service.dart';

void main() {
  group('LocalStorageService', () {
    late LocalStorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = LocalStorageService(prefs);
    });

    test('saves and reads access token', () async {
      await storage.saveAccessToken('test-token');

      expect(await storage.readAccessToken(), 'test-token');
    });

    test('clears tokens', () async {
      await storage.saveAccessToken('test-token');
      await storage.saveRefreshToken('refresh-token');

      await storage.clearTokens();

      expect(await storage.readAccessToken(), isNull);
      expect(await storage.readRefreshToken(), isNull);
    });

    test('saves and clears remember me credentials', () async {
      await storage.saveRememberMe(
        login: 'user@example.com',
        password: 'Password1!',
      );

      expect(await storage.isRememberMeEnabled(), isTrue);
      expect(await storage.readRememberedLogin(), 'user@example.com');
      expect(await storage.readRememberedPassword(), 'Password1!');

      await storage.clearRememberMe();

      expect(await storage.isRememberMeEnabled(), isFalse);
      expect(await storage.readRememberedLogin(), isNull);
      expect(await storage.readRememberedPassword(), isNull);
    });

    test('logout clears token but keeps remember me and onboarding', () async {
      await storage.saveAccessToken('token');
      await storage.setOnboardingComplete();
      await storage.saveRememberMe(
        login: 'user@example.com',
        password: 'Password1!',
      );

      await storage.clearTokens();

      expect(await storage.readAccessToken(), isNull);
      expect(await storage.hasSeenOnboarding(), isTrue);
      expect(await storage.readRememberedLogin(), 'user@example.com');
    });

    test('tracks onboarding completion', () async {
      expect(await storage.hasSeenOnboarding(), isFalse);

      await storage.setOnboardingComplete();

      expect(await storage.hasSeenOnboarding(), isTrue);
    });
  });
}
