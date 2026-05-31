import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static bool get enableFirebaseNotifications {
    return dotenv.env['ENABLE_FIREBASE_NOTIFICATIONS']?.toLowerCase() == 'true';
  }

  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
