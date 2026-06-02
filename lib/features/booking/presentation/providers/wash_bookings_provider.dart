import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../main/data/main_shell_mock_data.dart';
import '../../domain/repositories/booking_repository.dart';

class WashBookingsProvider extends ChangeNotifier {
  WashBookingsProvider(this._repository) {
    loadBookings();
  }

  final BookingRepository _repository;

  List<WashBookingMock> _bookings = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<WashBookingMock> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchBookings();

    result.fold(
      (failure) {
        _errorMessage = _messageFor(failure);
        _bookings = const [];
      },
      (bookings) {
        _bookings = bookings;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  String _messageFor(Failure failure) {
    return failure.message;
  }
}
