import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';
import '../error/failure_mapper.dart';
import '../network/api_client.dart';
import '../network/api_paths.dart';

class NotificationRemoteDataSource {
  const NotificationRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, void>> registerFcmToken({
    required String token,
    required String deviceType,
  }) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.fcmToken,
        data: {'fcm_token': token, 'device_type': deviceType},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }
}
