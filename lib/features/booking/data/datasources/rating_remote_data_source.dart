import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';

class RatingRemoteDataSource {
  const RatingRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, void>> submitRating({
    required String bookingId,
    required int rating,
    required String review,
  }) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.submitRating,
        data: {
          'booking_id': int.tryParse(bookingId) ?? bookingId,
          'rating': rating,
          'review': review,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchUserRatings() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.userRatings,
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final data = response.data?['data'];
      if (data is List) {
        return right(data.whereType<Map<String, dynamic>>().toList());
      }

      return right(const []);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }
}
