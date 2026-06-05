import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/failure_mapper.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_paths.dart';

class RewardsRemoteDataSource {
  const RewardsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, int>> fetchBalance() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.rewardsBalance,
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        final points = data['total_points'];
        if (points is int) {
          return right(points);
        }
        if (points is num) {
          return right(points.toInt());
        }
      }
      return right(0);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchTransactions() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.rewardsTransactions,
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        final items = data['data'];
        if (items is List) {
          return right(items.whereType<Map<String, dynamic>>().toList());
        }
      }
      return right([]);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, int>> redeemPoints({
    required int points,
    required String description,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.rewardsRedeem,
        data: {'points': points, 'description': description},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );

      final remaining = response.data?['data']?['remaining_points'];
      if (remaining is int) {
        return right(remaining);
      }
      return right(0);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }
}
