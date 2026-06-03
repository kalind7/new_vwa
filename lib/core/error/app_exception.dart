import 'package:dio/dio.dart';

import 'failure_mapper.dart';

/// User-safe application error mapped from network failures.
class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;

  static AppException fromDioException(DioException error) {
    final failure = mapDioException(error);
    return AppException(
      failure.message,
      statusCode: error.response?.statusCode,
    );
  }
}
