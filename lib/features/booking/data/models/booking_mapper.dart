import '../../../main/data/main_shell_mock_data.dart';

class BookingMapper {
  const BookingMapper._();

  static List<WashBookingMock> fromListResponse(Map<String, dynamic> json) {
    if (json['success'] == false) {
      return const [];
    }

    final data = json['data'];
    final bookings = data is Map<String, dynamic>
        ? data['bookings'] ?? data['data']
        : data;

    if (bookings is! List) {
      return const [];
    }

    return bookings
        .whereType<Map<String, dynamic>>()
        .map(_fromBookingJson)
        .toList();
  }

  static WashBookingMock fromDetailResponse(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return _fromBookingJson(data);
    }
    return _fromBookingJson(json);
  }

  static WashBookingMock fromCreateResponse(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return _fromBookingJson(data);
    }
    return _fromBookingJson(json);
  }

  static WashBookingMock _fromBookingJson(Map<String, dynamic> json) {
    final status = _normalizeStatus('${json['status'] ?? 'Booked'}');
    final stationName =
        '${json['service_station']?['name'] ?? json['station_name'] ?? json['station'] ?? 'Station'}';
    final location =
        '${json['service_station']?['address'] ?? json['location'] ?? json['address'] ?? ''}';
    final vehicleNumber =
        '${json['vehicle']?['vehicle_number'] ?? json['vehicle_number'] ?? ''}';
    final priceValue = json['total'] ?? json['amount'] ?? json['price'];
    final price = priceValue == null
        ? '—'
        : 'Rs ${_trimDecimal('$priceValue')}';
    final service =
        '${json['service'] ?? json['product_name'] ?? 'Exterior Wash'}';
    final dateLabel = _formatDate(json['booking_date'] ?? json['date']);
    final timeLabel = '${json['booking_time'] ?? json['time'] ?? ''}';

    return WashBookingMock(
      id: '${json['id'] ?? ''}',
      stationId: '${json['service_station_id'] ?? json['station_id'] ?? ''}',
      vehicleId: '${json['vehicle_id'] ?? ''}',
      station: stationName,
      location: location.isEmpty ? '—' : location,
      status: status,
      date: dateLabel,
      time: timeLabel,
      service: service,
      vehicle: vehicleNumber.isEmpty ? '—' : vehicleNumber,
      price: price,
      canCancel: status != 'Completed' && status != 'Cancelled',
    );
  }

  static String _normalizeStatus(String raw) {
    final value = raw.toLowerCase();
    if (value.contains('complete')) {
      return 'Completed';
    }
    if (value.contains('cancel')) {
      return 'Cancelled';
    }
    if (value.contains('wash')) {
      return 'Washing';
    }
    if (value.contains('book')) {
      return 'Booked';
    }
    return raw.isEmpty ? 'Booked' : raw;
  }

  static String _formatDate(Object? value) {
    if (value == null) {
      return 'Today';
    }
    final text = '$value';
    if (text.isEmpty) {
      return 'Today';
    }
    return text;
  }

  static String _trimDecimal(String value) {
    if (value.endsWith('.00')) {
      return value.substring(0, value.length - 3);
    }
    return value;
  }
}
