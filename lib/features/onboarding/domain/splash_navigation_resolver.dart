import '../../../core/storage/local_storage_service.dart';

enum SplashDestination { mainShell, onboarding, login }

class SplashNavigationResolver {
  const SplashNavigationResolver(this._localStorage);

  final LocalStorageService _localStorage;

  Future<SplashDestination> resolve() async {
    final token = await _localStorage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      return SplashDestination.mainShell;
    }

    final hasSeenOnboarding = await _localStorage.hasSeenOnboarding();
    if (!hasSeenOnboarding) {
      return SplashDestination.onboarding;
    }

    return SplashDestination.login;
  }
}
