import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static String get apiBaseUrl {
    const fromDefine = String.fromEnvironment('API_BASE_URL');
    if (fromDefine.trim().isNotEmpty) {
      return fromDefine;
    }
    return dotenv.env['API_BASE_URL'] ?? '';
  }

  static bool get useMockData {
    return dotenv.env['USE_MOCK_DATA']?.toLowerCase() != 'false';
  }

  static void validate() {
    if (useMockData) {
      return;
    }
    if (apiBaseUrl.trim().isEmpty) {
      throw StateError(
        'API_BASE_URL is not configured. Set it in assets/env/.env.',
      );
    }
  }

  static bool get enableFirebaseNotifications {
    return dotenv.env['ENABLE_FIREBASE_NOTIFICATIONS']?.toLowerCase() == 'true';
  }

  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
