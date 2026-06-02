import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vwa/core/storage/local_storage_service.dart';
import 'package:vwa/features/onboarding/domain/splash_navigation_resolver.dart';

class _MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  group('SplashNavigationResolver', () {
    late _MockLocalStorageService storage;
    late SplashNavigationResolver resolver;

    setUp(() {
      storage = _MockLocalStorageService();
      resolver = SplashNavigationResolver(storage);
    });

    test('routes to main shell when access token exists', () async {
      when(() => storage.readAccessToken()).thenAnswer((_) async => 'token');

      final destination = await resolver.resolve();

      expect(destination, SplashDestination.mainShell);
      verifyNever(() => storage.hasSeenOnboarding());
    });

    test('routes to onboarding for first-time users without token', () async {
      when(() => storage.readAccessToken()).thenAnswer((_) async => null);
      when(() => storage.hasSeenOnboarding()).thenAnswer((_) async => false);

      final destination = await resolver.resolve();

      expect(destination, SplashDestination.onboarding);
    });

    test(
      'routes to login when onboarding was completed and token is missing',
      () async {
        when(() => storage.readAccessToken()).thenAnswer((_) async => null);
        when(() => storage.hasSeenOnboarding()).thenAnswer((_) async => true);

        final destination = await resolver.resolve();

        expect(destination, SplashDestination.login);
      },
    );
  });

  group('SplashNavigationResolver integration', () {
    test('uses real shared preferences values', () async {
      SharedPreferences.setMockInitialValues({
        'access_token': 'saved-token',
        'has_seen_onboarding': false,
      });
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageService(prefs);
      final resolver = SplashNavigationResolver(storage);

      expect(await resolver.resolve(), SplashDestination.mainShell);
    });
  });
}
