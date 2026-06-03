import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/core/error/failure.dart';
import 'package:vwa/core/error/failure_mapper.dart';

void main() {
  group('mapDioException', () {
    test('maps connection error to NetworkFailure', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'Check your connection.');
    });

    test('maps 401 with API message to UnauthorizedFailure', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 401,
            data: {
              'message': 'These credentials do not match our records.',
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<UnauthorizedFailure>());
      expect(
        failure.message,
        'These credentials do not match our records.',
      );
    });

    test('maps 401 without body to default UnauthorizedFailure', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me'),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'Unauthorized.');
    });

    test('maps 401 Unauthenticated from protected route', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me'),
            statusCode: 401,
            data: {'message': 'Unauthenticated.'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure.message, 'Unauthenticated.');
    });

    test('maps 403 with API message', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/bookings'),
          response: Response(
            requestOptions: RequestOptions(path: '/bookings'),
            statusCode: 403,
            data: {'message': 'This action is unauthorized.'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<UnknownFailure>());
      expect(failure.message, 'This action is unauthorized.');
    });

    test('maps 404 with API message', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(
            path: '/service-stations/999999',
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: '/service-stations/999999',
            ),
            statusCode: 404,
            data: {'message': 'Service station not found.'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<UnknownFailure>());
      expect(failure.message, 'Service station not found.');
    });

    test('maps 422 with message to ValidationFailure', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/register'),
            statusCode: 422,
            data: {'message': 'The email has already been taken.'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'The email has already been taken.');
    });

    test('maps 500 with API message to ServerFailure', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/bookings'),
          response: Response(
            requestOptions: RequestOptions(path: '/bookings'),
            statusCode: 500,
            data: {'message': 'Server Error'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Server Error');
    });

    test('uses field errors when headline is generic on 422', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/register'),
            statusCode: 422,
            data: {
              'success': false,
              'message': 'Validation error',
              'errors': {
                'email': ['The email has already been taken.'],
                'phone': ['The phone has already been taken.'],
              },
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<ValidationFailure>());
      expect(
        failure.message,
        'The email has already been taken. · The phone has already been taken.',
      );
    });

    test('falls back to first field error when message is absent', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/register'),
            statusCode: 422,
            data: {
              'errors': {
                'email': ['Enter a valid email address.'],
              },
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure.message, 'Enter a valid email address.');
    });
  });

  group('mapHttpErrorResponse', () {
    test('maps 401 without throwing DioException', () {
      final failure = mapHttpErrorResponse(
        statusCode: 401,
        responseData: {'message': 'Unauthenticated.'},
      );

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'Unauthenticated.');
    });
  });
}
