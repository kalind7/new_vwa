import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../models/login_response.dart';
import '../models/register_response.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, LoginResponse>> login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.authLogin,
        data: {'login': login, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid login response from server.'),
        );
      }

      return right(LoginResponse.fromJson(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on FormatException {
      return left(const UnknownFailure('Invalid login response from server.'));
    }
  }

  Future<Either<Failure, RegisterResponse>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.authRegister,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid register response from server.'),
        );
      }

      return right(RegisterResponse.fromJson(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on FormatException {
      return left(
        const UnknownFailure('Invalid register response from server.'),
      );
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(ApiPaths.authLogout);
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }
}
