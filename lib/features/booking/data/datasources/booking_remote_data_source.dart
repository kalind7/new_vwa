import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../../../main/data/booking_flow_mock_data.dart';
import '../../../main/data/main_shell_mock_data.dart';
import '../../domain/booking_flow_helpers.dart';
import '../models/booking_mapper.dart';

class BookingRemoteDataSource {
  const BookingRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Either<Failure, WashBookingMock>> createBooking(
    BookingDraft draft,
  ) async {
    try {
      final stationId = int.tryParse(draft.station.id);
      final vehicleId = int.tryParse(draft.vehicle?.id ?? '');
      if (stationId == null || vehicleId == null) {
        return left(
          const ValidationFailure('Station or vehicle is missing for booking.'),
        );
      }

      final productId = selectedProductId(draft) ??
          (draft.station.products.isNotEmpty
              ? draft.station.products.first.id
              : 1);

      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.bookings,
        data: {
          'service_station_id': stationId,
          'vehicle_id': vehicleId,
          'booking_date': _bookingDate(draft),
          'booking_time': normalizeBookingTime(draft.slot.timeLabel),
          'products': [
            {'id': productId, 'quantity': 1},
          ],
          'payment_method': mapPaymentMethodForApi(draft.paymentMethod?.id),
          if (draft.promoCode != null && draft.promoCode!.isNotEmpty)
            'promo_code': draft.promoCode,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: const {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid booking response from server.'),
        );
      }

      return right(BookingMapper.fromCreateResponse(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on FormatException {
      return left(
        const UnknownFailure('Invalid booking response from server.'),
      );
    }
  }

  Future<Either<Failure, List<WashBookingMock>>> fetchBookings() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.bookings,
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid bookings response from server.'),
        );
      }

      return right(BookingMapper.fromListResponse(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  Future<Either<Failure, WashBookingMock>> fetchBookingDetail(
    String bookingId,
  ) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiPaths.bookingDetails(bookingId),
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final data = response.data;
      if (data == null) {
        return left(
          const UnknownFailure('Invalid booking detail response from server.'),
        );
      }

      return right(BookingMapper.fromDetailResponse(data));
    } on DioException catch (error) {
      return left(mapDioException(error));
    } on FormatException {
      return left(
        const UnknownFailure('Invalid booking detail response from server.'),
      );
    }
  }

  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiPaths.cancelBooking(bookingId),
        options: Options(headers: const {'Accept': 'application/json'}),
      );
      return right(null);
    } on DioException catch (error) {
      return left(mapDioException(error));
    }
  }

  String _bookingDate(BookingDraft draft) {
    final label = draft.slot.dateLabel.toLowerCase();
    if (label == 'today') {
      final now = DateTime.now();
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    if (label == 'tomorrow') {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      return '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
    }
    return draft.slot.dayLabel;
  }
}
