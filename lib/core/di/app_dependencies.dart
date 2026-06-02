import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/main/data/api_wash_station_repository.dart';
import '../../features/main/data/wash_station_repository.dart';
import '../network/api_client.dart';
import '../storage/local_storage_service.dart';

class AppDependencies {
  AppDependencies._({
    required this.localStorage,
    required this.apiClient,
    required this.authRepository,
    required this.washStationRepository,
  });

  final LocalStorageService localStorage;
  final ApiClient apiClient;
  final AuthRepository authRepository;
  final WashStationRepository washStationRepository;

  static AppDependencies? instance;

  static Future<AppDependencies> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorageService(prefs);
    final apiClient = ApiClient(
      localStorage,
      onUnauthorized: localStorage.clearTokens,
    );
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSource(apiClient),
      localStorage: localStorage,
    );
    final washStationRepository = AppConfig.useMockData
        ? const MockWashStationRepository()
        : ApiWashStationRepository(apiClient);

    final dependencies = AppDependencies._(
      localStorage: localStorage,
      apiClient: apiClient,
      authRepository: authRepository,
      washStationRepository: washStationRepository,
    );
    instance = dependencies;
    return dependencies;
  }

  /// Lightweight dependencies for widget tests (mock data, no network).
  static Future<AppDependencies> testing({
    Map<String, Object> initialValues = const {},
  }) async {
    SharedPreferences.setMockInitialValues(initialValues);
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorageService(prefs);
    final apiClient = ApiClient(localStorage);
    final dependencies = AppDependencies._(
      localStorage: localStorage,
      apiClient: apiClient,
      authRepository: AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSource(apiClient),
        localStorage: localStorage,
      ),
      washStationRepository: const MockWashStationRepository(),
    );
    instance = dependencies;
    return dependencies;
  }
}
