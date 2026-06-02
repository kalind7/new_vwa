import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../models/user_profile.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, UserProfile>> fetchProfile() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.authMe,
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid profile response from server.'),
        );
      }

      return right(UserProfile.fromJson(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on FormatException {
      return left(
        const UnknownFailure('Invalid profile response from server.'),
      );
    }
  }

  Future<Either<Failure, UserProfile>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await _apiClient.dio.put<Map<String, dynamic>>(
        ApiPaths.authMe,
        data: {'name': name, 'email': email, 'phone': phone},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid profile response from server.'),
        );
      }

      return right(UserProfile.fromJson(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on FormatException {
      return left(
        const UnknownFailure('Invalid profile response from server.'),
      );
    }
  }
}
