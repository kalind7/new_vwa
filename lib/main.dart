import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app/vwa_app.dart';
import 'config/app_config.dart';
import 'core/connectivity/connectivity_provider.dart';
import 'core/di/app_dependencies.dart';
import 'core/services/notification_service.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/booking/data/datasources/payment_remote_data_source.dart';
import 'features/booking/data/datasources/rating_remote_data_source.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/presentation/providers/wash_bookings_provider.dart';
import 'features/main/data/wash_station_repository.dart';
import 'features/main/presentation/providers/saved_stations_provider.dart';
import 'features/profile/domain/repositories/user_repository.dart';
import 'features/profile/presentation/providers/user_profile_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/env/.env');
  AppConfig.validate();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final dependencies = await AppDependencies.initialize();

  if (AppConfig.enableFirebaseNotifications) {
    final notificationService = NotificationService(
      notificationRemote: dependencies.notificationRemoteDataSource,
    );
    await notificationService.initialize();
    await notificationService.syncTokenWithBackend();
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDependencies>.value(value: dependencies),
        Provider<AuthRepository>.value(value: dependencies.authRepository),
        Provider<UserRepository>.value(value: dependencies.userRepository),
        Provider<WashStationRepository>.value(
          value: dependencies.washStationRepository,
        ),
        Provider<BookingRepository>.value(
          value: dependencies.bookingRepository,
        ),
        Provider<PaymentRemoteDataSource>.value(
          value: dependencies.paymentRemoteDataSource,
        ),
        Provider<RatingRemoteDataSource>.value(
          value: dependencies.ratingRemoteDataSource,
        ),
        ChangeNotifierProvider(
          create: (context) =>
              WashBookingsProvider(context.read<BookingRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => SavedStationsProvider(
            dependencies.savedStationsRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              UserProfileProvider(context.read<UserRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const VwaApp(),
    ),
  );
}
