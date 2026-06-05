import '../../main/data/booking_flow_mock_data.dart';
import '../../main/data/main_shell_mock_data.dart';

/// Maps station API products into checkout service options.
List<WashServiceMock> servicesFromStation(WashStationMock station) {
  if (station.products.isNotEmpty) {
    return station.products
        .map(
          (product) => WashServiceMock(
            id: product.id.toString(),
            title: product.name,
            subtitle: 'At ${station.name}',
            duration: '30 minute',
            price: product.price ?? station.price,
          ),
        )
        .toList();
  }

  if (station.serviceNames.isNotEmpty) {
    return station.serviceNames
        .asMap()
        .entries
        .map(
          (entry) => WashServiceMock(
            id: 'service-${entry.key}',
            title: entry.value,
            subtitle: 'At ${station.name}',
            duration: '30 minute',
            price: station.price,
          ),
        )
        .toList();
  }

  return washServices;
}

/// Generates bookable slots (client-side until backend slot API exists).
List<WashSlotMock> slotsFromStation(WashStationMock station) {
  const times = ['09:00', '10:00', '11:30', '14:00', '16:00'];
  final now = DateTime.now();
  final todayLabel =
      '${_month(now.month)} ${now.day}';
  final tomorrow = now.add(const Duration(days: 1));
  final tomorrowLabel =
      '${_month(tomorrow.month)} ${tomorrow.day}';

  final slots = <WashSlotMock>[];
  for (var i = 0; i < times.length; i++) {
    slots.add(
      WashSlotMock(
        id: 'today-$i',
        dateLabel: 'Today',
        dayLabel: todayLabel,
        timeLabel: times[i],
      ),
    );
  }
  for (var i = 0; i < 3; i++) {
    slots.add(
      WashSlotMock(
        id: 'tomorrow-$i',
        dateLabel: 'Tomorrow',
        dayLabel: tomorrowLabel,
        timeLabel: times[i],
      ),
    );
  }
  return slots;
}

String _month(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[month - 1];
}

/// Converts UI slot labels to API `H:i` format.
String normalizeBookingTime(String timeLabel) {
  final trimmed = timeLabel.trim();
  if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(trimmed)) {
    final parts = trimmed.split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1]}';
  }

  final match = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?', caseSensitive: false)
      .firstMatch(trimmed);
  if (match == null) {
    return '10:00';
  }

  var hour = int.parse(match.group(1)!);
  final minute = match.group(2)!;
  final meridiem = match.group(3)?.toUpperCase();

  if (meridiem == 'PM' && hour < 12) {
    hour += 12;
  } else if (meridiem == 'AM' && hour == 12) {
    hour = 0;
  }

  return '${hour.toString().padLeft(2, '0')}:$minute';
}

/// Maps UI payment ids to API values (`cod` | `online`).
String mapPaymentMethodForApi(String? methodId) {
  return switch (methodId) {
    'khalti' || 'esewa' => 'online',
    'cod' || 'cash' => 'cod',
    _ => 'cod',
  };
}

int? selectedProductId(BookingDraft draft) {
  return int.tryParse(draft.service.id);
}
