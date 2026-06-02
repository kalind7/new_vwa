import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app/vwa_app.dart';
import 'config/app_config.dart';
import 'core/di/app_dependencies.dart';
import 'core/services/notification_service.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/main/data/wash_station_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/env/.env');
  AppConfig.validate();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (AppConfig.enableFirebaseNotifications) {
    await NotificationService().initialize();
  }

  final dependencies = await AppDependencies.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDependencies>.value(value: dependencies),
        Provider<AuthRepository>.value(value: dependencies.authRepository),
        Provider<WashStationRepository>.value(
          value: dependencies.washStationRepository,
        ),
      ],
      child: const VwaApp(),
    ),
  );
}
