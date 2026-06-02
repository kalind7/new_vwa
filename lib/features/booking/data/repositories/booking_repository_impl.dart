import 'package:fpdart/fpdart.dart';

import '../../../../config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../../main/data/booking_flow_mock_data.dart';
import '../../../main/data/main_shell_mock_data.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl({required BookingRemoteDataSource remote})
    : _remote = remote;

  final BookingRemoteDataSource _remote;

  @override
  Future<Either<Failure, WashBookingMock>> createBooking(
    BookingDraft draft,
  ) async {
    if (AppConfig.useMockData) {
      return right(
        WashBookingMock(
          id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
          station: draft.station.name,
          location: draft.station.location,
          status: 'Booked',
          date: draft.slot.dateLabel,
          time: draft.slot.timeLabel,
          service: draft.service.title,
          vehicle: draft.vehicle?.plate ?? '—',
          price: checkoutTotalLabel(draft),
          canCancel: true,
          stationId: draft.station.id,
          vehicleId: draft.vehicle?.id,
        ),
      );
    }

    return _remote.createBooking(draft);
  }

  @override
  Future<Either<Failure, List<WashBookingMock>>> fetchBookings() async {
    if (AppConfig.useMockData) {
      return right(washBookings);
    }

    return _remote.fetchBookings();
  }

  @override
  Future<Either<Failure, WashBookingMock>> fetchBookingDetail(
    String bookingId,
  ) async {
    if (AppConfig.useMockData) {
      for (final booking in washBookings) {
        if (booking.id == bookingId) {
          return right(booking);
        }
      }
      return right(washBookings.first);
    }

    return _remote.fetchBookingDetail(bookingId);
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    if (AppConfig.useMockData) {
      return right(null);
    }

    return _remote.cancelBooking(bookingId);
  }
}
