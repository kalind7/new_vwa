import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../models/promo_validation_result.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';

class PaymentRemoteDataSource {
  const PaymentRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, PromoValidationResult>> validatePromoCode({
    required String code,
    required double amount,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.validateBookingPromo,
        data: {'code': code, 'total_amount': amount},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if (data == null) {
        return left(const UnknownFailure('Invalid promo response.'));
      }

      final payload = data['data'];
      final discount = payload is Map<String, dynamic>
          ? (payload['discount_amount'] as num?)?.toDouble() ?? 0
          : 0.0;
      final finalAmount = payload is Map<String, dynamic>
          ? (payload['final_amount'] as num?)?.toDouble() ?? amount
          : amount;

      return right(
        PromoValidationResult(
          message: '${data['message'] ?? 'Promo code applied.'}',
          discountAmount: discount,
          finalAmount: finalAmount,
          code: code,
        ),
      );
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
