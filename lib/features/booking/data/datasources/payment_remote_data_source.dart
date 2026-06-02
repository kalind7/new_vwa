import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';

class PaymentRemoteDataSource {
  const PaymentRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, String>> validatePromoCode({
    required String code,
    required double amount,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.validatePromoCode,
        data: {'code': code, 'amount': amount},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if (data == null) {
        return left(const UnknownFailure('Invalid promo response.'));
      }

      final message = '${data['message'] ?? 'Promo code applied.'}';
      return right(message);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> initiatePayment({
    required String bookingId,
    required String paymentMethod,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.initiatePayment,
        data: {
          'booking_id': int.tryParse(bookingId) ?? bookingId,
          'payment_method': paymentMethod,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if (data == null) {
        return left(const UnknownFailure('Invalid payment response.'));
      }

      return right(data);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }
}
