import 'package:dio/dio.dart';

import 'api_response_message.dart';
import 'failure.dart';

Failure mapDioException(DioException error) {
  final statusCode = error.response?.statusCode;
  final responseData = error.response?.data;
  final apiMessage = formatApiErrorForUser(responseData);

  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout) {
    return const NetworkFailure();
  }

  if (error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return const NetworkFailure('Request timed out. Please try again.');
  }

  if (statusCode == 401) {
    return UnauthorizedFailure(
      apiMessage ?? const UnauthorizedFailure().message,
    );
  }

  if (statusCode == 403) {
    return UnknownFailure(
      apiMessage ?? 'You do not have permission to perform this action.',
    );
  }

  if (statusCode == 404) {
    return UnknownFailure(
      apiMessage ?? 'The requested resource was not found.',
    );
  }

  if (statusCode == 422) {
    return ValidationFailure(
      apiMessage ?? 'Please check your input and try again.',
      statusCode: 422,
    );
  }

  if (statusCode != null && statusCode >= 500) {
    return ServerFailure(
      apiMessage ?? 'Something went wrong. Please try again later.',
      statusCode: statusCode,
    );
  }

  if (apiMessage != null && apiMessage.isNotEmpty) {
    return UnknownFailure(apiMessage);
  }

  return UnknownFailure(
    error.message ?? 'Something went wrong. Please try again.',
  );
}

/// Maps a non-2xx HTTP response when Dio [validateStatus] accepts the body.
Failure mapHttpErrorResponse({
  required int statusCode,
  dynamic responseData,
}) {
  final apiMessage = formatApiErrorForUser(responseData);

  if (statusCode == 401) {
    return UnauthorizedFailure(
      apiMessage ?? const UnauthorizedFailure().message,
    );
  }

  if (statusCode == 403) {
    return UnknownFailure(
      apiMessage ?? 'You do not have permission to perform this action.',
    );
  }

  if (statusCode == 404) {
    return UnknownFailure(
      apiMessage ?? 'The requested resource was not found.',
    );
  }

  if (statusCode == 422) {
    return ValidationFailure(
      apiMessage ?? 'Please check your input and try again.',
      statusCode: 422,
    );
  }

  if (statusCode >= 500) {
    return ServerFailure(
      apiMessage ?? 'Something went wrong. Please try again later.',
      statusCode: statusCode,
    );
  }

  if (apiMessage != null && apiMessage.isNotEmpty) {
    return UnknownFailure(apiMessage);
  }

  return UnknownFailure('Request failed with status $statusCode.');
}
