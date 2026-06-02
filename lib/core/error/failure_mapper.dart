import 'package:dio/dio.dart';

import 'failure.dart';

Failure mapDioException(DioException error) {
  final statusCode = error.response?.statusCode;
  final responseData = error.response?.data;

  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout) {
    return const NetworkFailure();
  }

  if (error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return const NetworkFailure('Request timed out. Please try again.');
  }

  if (statusCode == 401) {
    return const UnauthorizedFailure();
  }

  if (statusCode == 422) {
    return ValidationFailure(
      _messageFromResponse(responseData) ??
          'Please check your input and try again.',
    );
  }

  if (statusCode != null && statusCode >= 500) {
    return ServerFailure(
      'Something went wrong. Please try again later.',
      statusCode: statusCode,
    );
  }

  final apiMessage = _messageFromResponse(responseData);
  if (apiMessage != null && apiMessage.isNotEmpty) {
    return UnknownFailure(apiMessage);
  }

  return UnknownFailure(
    error.message ?? 'Something went wrong. Please try again.',
  );
}

String? _messageFromResponse(dynamic data) {
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
