import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../main/data/booking_flow_mock_data.dart';
import '../../../main/data/main_shell_mock_data.dart';

abstract class BookingRepository {
  Future<Either<Failure, WashBookingMock>> createBooking(BookingDraft draft);

  Future<Either<Failure, List<WashBookingMock>>> fetchBookings();

  Future<Either<Failure, WashBookingMock>> fetchBookingDetail(String bookingId);

  Future<Either<Failure, void>> cancelBooking(String bookingId);
}
