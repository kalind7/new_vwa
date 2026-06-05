import 'main_shell_mock_data.dart';

class WashServiceMock {
  const WashServiceMock({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.price,
  });

  final String id;
  final String title;
  final String subtitle;
  final String duration;
  final String price;
}

class WashSlotMock {
  const WashSlotMock({
    required this.id,
    required this.dateLabel,
    required this.dayLabel,
    required this.timeLabel,
  });

  final String id;
  final String dateLabel;
  final String dayLabel;
  final String timeLabel;
}

class PaymentMethodMock {
  const PaymentMethodMock({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String title;
  final String subtitle;
}

class StationBookingArgs {
  const StationBookingArgs({required this.station, required this.vehicle});

  final WashStationMock station;
  final VehicleMock vehicle;
}

class VehicleMock {
  const VehicleMock({
    required this.id,
    required this.plate,
    this.isDefault = false,
    this.vehicleType = 'bike',
  });

  final String id;
  final String plate;
  final bool isDefault;
  final String vehicleType;

  VehicleMock copyWith({
    String? id,
    String? plate,
    bool? isDefault,
    String? vehicleType,
  }) {
    return VehicleMock(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      isDefault: isDefault ?? this.isDefault,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }
}

class BookingDraft {
  const BookingDraft({
    required this.station,
    required this.service,
    required this.slot,
    this.vehicle,
    this.paymentMethod,
    this.checkoutTotal,
    this.promoCode,
    this.bookingId,
    this.isSuccess = true,
    this.isExistingBookingCheckout = false,
    this.promoDiscountAmount,
    this.discountedTotal,
  });

  final WashStationMock station;
  final WashServiceMock service;
  final WashSlotMock slot;
  final VehicleMock? vehicle;
  final PaymentMethodMock? paymentMethod;
  final String? checkoutTotal;
  final String? promoCode;
  final String? bookingId;
  final bool isSuccess;

  /// When true, checkout is for an existing booking (My Wash flow) — never create again.
  final bool isExistingBookingCheckout;
  final double? promoDiscountAmount;
  final String? discountedTotal;

  BookingDraft copyWith({
    WashStationMock? station,
    WashServiceMock? service,
    WashSlotMock? slot,
    VehicleMock? vehicle,
    PaymentMethodMock? paymentMethod,
    String? checkoutTotal,
    String? promoCode,
    String? bookingId,
    bool? isSuccess,
    bool? isExistingBookingCheckout,
    double? promoDiscountAmount,
    String? discountedTotal,
  }) {
    return BookingDraft(
      station: station ?? this.station,
      service: service ?? this.service,
      slot: slot ?? this.slot,
      vehicle: vehicle ?? this.vehicle,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      checkoutTotal: checkoutTotal ?? this.checkoutTotal,
      promoCode: promoCode ?? this.promoCode,
      bookingId: bookingId ?? this.bookingId,
      isSuccess: isSuccess ?? this.isSuccess,
      isExistingBookingCheckout:
          isExistingBookingCheckout ?? this.isExistingBookingCheckout,
      promoDiscountAmount: promoDiscountAmount ?? this.promoDiscountAmount,
      discountedTotal: discountedTotal ?? this.discountedTotal,
    );
  }
}

String checkoutDurationLabel(String duration) {
  if (duration.contains('minute')) {
    return duration;
  }
  final digits = duration.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) {
    return duration;
  }
  return '$digits minute';
}

String checkoutTotalLabel(BookingDraft draft) {
  if (draft.discountedTotal != null && draft.discountedTotal!.isNotEmpty) {
    return draft.discountedTotal!;
  }
  if (draft.checkoutTotal != null) {
    return draft.checkoutTotal!;
  }
  return draft.service.price.replaceFirst('Nrs ', 'Rs ');
}

BookingDraft bookingDraftForStation({
  required WashStationMock station,
  required VehicleMock vehicle,
}) {
  return BookingDraft(
    station: station,
    service: washServices.first,
    slot: washSlots.first,
    vehicle: vehicle,
  );
}

BookingDraft bookingDraftFromWashBooking(WashBookingMock booking) {
  final station = booking.stationId != null && booking.stationId!.isNotEmpty
      ? nearbyStations.firstWhere(
          (item) => item.id == booking.stationId,
          orElse: () => nearbyStations.firstWhere(
            (item) => item.name == booking.station,
            orElse: () => nearbyStations.first,
          ),
        )
      : nearbyStations.firstWhere(
          (item) => item.name == booking.station,
          orElse: () => nearbyStations.first,
        );
  final service = washServices.firstWhere(
    (item) => item.title == booking.service,
    orElse: () => washServices.first,
  );
  final vehicle = booking.vehicleId != null && booking.vehicleId!.isNotEmpty
      ? VehicleMock(id: booking.vehicleId!, plate: booking.vehicle)
      : VehicleMock(id: 'wash-${booking.vehicle}', plate: booking.vehicle);

  return BookingDraft(
    station: station,
    service: service,
    slot: washSlots.first,
    vehicle: vehicle,
    checkoutTotal: booking.price,
    bookingId: booking.id,
    isExistingBookingCheckout: true,
  );
}

const vehicles = [
  VehicleMock(id: '1', plate: 'Ba- pa-1024'),
  VehicleMock(id: '2', plate: 'Ba-pa 2045'),
  VehicleMock(id: '3', plate: 'Ba-pa 1097'),
  VehicleMock(id: '4', plate: 'Ba-pa 9873'),
];

const washServices = [
  WashServiceMock(
    id: 'exterior',
    title: 'Exterior Wash',
    subtitle: 'Foam wash, rinse, and dry for daily bike care.',
    duration: '30 minute',
    price: 'Nrs 100',
  ),
  WashServiceMock(
    id: 'full-bike',
    title: 'Full Bike Wash',
    subtitle: 'Exterior wash with tyre, chain cover, and seat cleaning.',
    duration: '40 min',
    price: 'Nrs 150',
  ),
  WashServiceMock(
    id: 'premium',
    title: 'Premium Detailing',
    subtitle: 'Deep cleaning, polish, dashboard wipe, and finishing coat.',
    duration: '60 min',
    price: 'Nrs 250',
  ),
];

const washSlots = [
  WashSlotMock(
    id: 'today-10',
    dateLabel: 'Today',
    dayLabel: 'Jun 2',
    timeLabel: '10:00 AM',
  ),
  WashSlotMock(
    id: 'today-1130',
    dateLabel: 'Today',
    dayLabel: 'Jun 2',
    timeLabel: '11:30 AM',
  ),
  WashSlotMock(
    id: 'tomorrow-9',
    dateLabel: 'Tomorrow',
    dayLabel: 'Jun 3',
    timeLabel: '09:00 AM',
  ),
  WashSlotMock(
    id: 'tomorrow-4',
    dateLabel: 'Tomorrow',
    dayLabel: 'Jun 3',
    timeLabel: '04:00 PM',
  ),
];

const paymentMethods = [
  PaymentMethodMock(
    id: 'khalti',
    title: 'Khalti',
    subtitle: 'Pay with Khalti wallet',
  ),
  PaymentMethodMock(
    id: 'esewa',
    title: 'eSewa',
    subtitle: 'Pay with eSewa wallet',
  ),
  PaymentMethodMock(
    id: 'cod',
    title: 'Cash on Delivery',
    subtitle: 'Pay when your wash is complete',
  ),
];
