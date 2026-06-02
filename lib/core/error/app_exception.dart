import 'package:dio/dio.dart';

/// User-safe application error mapped from network failures.
class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;

  static AppException fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const AppException('Check your connection.');
    }

    if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const AppException('Request timed out. Please try again.');
    }

    if (statusCode == 401) {
      return const AppException(
        'Invalid email or password.',
        statusCode: 401,
      );
    }

    if (statusCode == 422) {
      return AppException(
        _messageFromResponse(responseData) ??
            'Please check your input and try again.',
        statusCode: 422,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return AppException(
        'Something went wrong. Please try again later.',
        statusCode: statusCode,
      );
    }

    final apiMessage = _messageFromResponse(responseData);
    if (apiMessage != null && apiMessage.isNotEmpty) {
      return AppException(apiMessage, statusCode: statusCode);
    }

    return AppException(
      error.message ?? 'Something went wrong. Please try again.',
      statusCode: statusCode,
    );
  }

  static String? _messageFromResponse(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final map = Map<String, dynamic>.from(data);
    final message = map['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    final error = map['error'];
    if (error is String && error.isNotEmpty) {
      return error;
    }

    final errors = map['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          final first = value.first;
          if (first is String && first.isNotEmpty) {
            return first;
          }
        }
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }
}
