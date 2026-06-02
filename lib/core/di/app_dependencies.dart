import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/booking/data/datasources/booking_remote_data_source.dart';
import '../../features/booking/data/datasources/payment_remote_data_source.dart';
import '../../features/booking/data/datasources/rating_remote_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/main/data/api_wash_station_repository.dart';
import '../../features/main/data/saved_station_ids_storage.dart';
import '../../features/main/data/saved_stations_repository.dart';
import '../../features/main/data/wash_station_repository.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/datasources/vehicle_remote_data_source.dart';
import '../../features/profile/data/repositories/user_repository_impl.dart';
import '../../features/profile/domain/repositories/user_repository.dart';
import '../network/api_client.dart';
import '../services/notification_remote_data_source.dart';
import '../storage/local_storage_service.dart';

class AppDependencies {
  AppDependencies._({
    required this.localStorage,
    required this.apiClient,
    required this.authRepository,
    required this.userRepository,
    required this.washStationRepository,
    required this.bookingRepository,
    required this.paymentRemoteDataSource,
    required this.ratingRemoteDataSource,
    required this.notificationRemoteDataSource,
    required this.savedStationsRepository,
  });

  final LocalStorageService localStorage;
  final ApiClient apiClient;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final WashStationRepository washStationRepository;
  final BookingRepository bookingRepository;
  final PaymentRemoteDataSource paymentRemoteDataSource;
  final RatingRemoteDataSource ratingRemoteDataSource;
  final NotificationRemoteDataSource notificationRemoteDataSource;
  final SavedStationsRepository savedStationsRepository;

  static AppDependencies? instance;

  static Future<AppDependencies> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorageService(prefs);
    final apiClient = ApiClient(
      localStorage,
      onUnauthorized: localStorage.clearTokens,
    );
    final authRemote = AuthRemoteDataSource(apiClient);
    final profileRemote = ProfileRemoteDataSource(apiClient);
    final vehicleRemote = VehicleRemoteDataSource(apiClient);
    final bookingRemote = BookingRemoteDataSource(apiClient);
    final paymentRemote = PaymentRemoteDataSource(apiClient);
    final ratingRemote = RatingRemoteDataSource(apiClient);
    final notificationRemote = NotificationRemoteDataSource(apiClient);
    final washStationRepository = AppConfig.useMockData
        ? const MockWashStationRepository()
        : ApiWashStationRepository(apiClient);
    final savedIdsStorage = SavedStationIdsStorage(prefs);

    final dependencies = AppDependencies._(
      localStorage: localStorage,
      apiClient: apiClient,
      authRepository: AuthRepositoryImpl(
        remoteDataSource: authRemote,
        localStorage: localStorage,
      ),
      userRepository: UserRepositoryImpl(
        profileRemoteDataSource: profileRemote,
        vehicleRemoteDataSource: vehicleRemote,
      ),
      washStationRepository: washStationRepository,
      bookingRepository: BookingRepositoryImpl(remote: bookingRemote),
      paymentRemoteDataSource: paymentRemote,
      ratingRemoteDataSource: ratingRemote,
      notificationRemoteDataSource: notificationRemote,
      savedStationsRepository: SavedStationsRepository(
        storage: savedIdsStorage,
        stationRepository: washStationRepository,
      ),
    );
    instance = dependencies;
    return dependencies;
  }

  static Future<AppDependencies> testing({
    Map<String, Object> initialValues = const {},
  }) async {
    SharedPreferences.setMockInitialValues(initialValues);
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorageService(prefs);
    final apiClient = ApiClient(localStorage);
    final profileRemote = ProfileRemoteDataSource(apiClient);
    final vehicleRemote = VehicleRemoteDataSource(apiClient);
    final bookingRemote = BookingRemoteDataSource(apiClient);
    final paymentRemote = PaymentRemoteDataSource(apiClient);
    final ratingRemote = RatingRemoteDataSource(apiClient);
    final notificationRemote = NotificationRemoteDataSource(apiClient);
    const washStationRepository = MockWashStationRepository();
    final savedIdsStorage = SavedStationIdsStorage(prefs);

    final dependencies = AppDependencies._(
      localStorage: localStorage,
      apiClient: apiClient,
      authRepository: AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSource(apiClient),
        localStorage: localStorage,
      ),
      userRepository: UserRepositoryImpl(
        profileRemoteDataSource: profileRemote,
        vehicleRemoteDataSource: vehicleRemote,
      ),
      washStationRepository: washStationRepository,
      bookingRepository: BookingRepositoryImpl(remote: bookingRemote),
      paymentRemoteDataSource: paymentRemote,
      ratingRemoteDataSource: ratingRemote,
      notificationRemoteDataSource: notificationRemote,
      savedStationsRepository: SavedStationsRepository(
        storage: savedIdsStorage,
        stationRepository: washStationRepository,
      ),
    );
    instance = dependencies;
    return dependencies;
  }
}
