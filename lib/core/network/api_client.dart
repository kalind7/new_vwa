import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../config/app_config.dart';
import '../error/app_exception.dart';
import '../storage/local_storage_service.dart';

typedef UnauthorizedCallback = Future<void> Function();

class ApiClient {
  ApiClient(this._localStorage, {UnauthorizedCallback? onUnauthorized})
    : _onUnauthorized = onUnauthorized {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _localStorage.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final onUnauthorized = _onUnauthorized;
          if (error.response?.statusCode == 401 &&
              onUnauthorized != null &&
              !_isAuthRequest(error.requestOptions.path)) {
            await onUnauthorized();
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }
  }

  final LocalStorageService _localStorage;
  final UnauthorizedCallback? _onUnauthorized;
  late final Dio _dio;

  Dio get dio => _dio;

  static bool _isAuthRequest(String path) {
    return path.contains('auth/login') ||
        path.contains('auth/register') ||
        path.contains('auth/forgot-password') ||
        path.contains('auth/reset-password');
  }

  Never rethrowAsAppException(DioException error) {
    throw AppException.fromDioException(error);
  }
}
