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

    test('maps 401 to UnauthorizedFailure', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<UnauthorizedFailure>());
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

    test('maps 500 to ServerFailure', () {
      final failure = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 500,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(failure, isA<ServerFailure>());
    });

    test('extracts first validation error from errors map', () {
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
}
