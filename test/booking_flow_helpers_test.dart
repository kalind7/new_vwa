import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/features/booking/domain/booking_flow_helpers.dart';

void main() {
  group('normalizeBookingTime', () {
    test('returns 24h format unchanged', () {
      expect(normalizeBookingTime('10:00'), '10:00');
      expect(normalizeBookingTime('14:30'), '14:30');
    });

    test('converts AM/PM labels', () {
      expect(normalizeBookingTime('10:00 AM'), '10:00');
      expect(normalizeBookingTime('4:00 PM'), '16:00');
    });
  });

  group('mapPaymentMethodForApi', () {
    test('maps wallet and cod ids', () {
      expect(mapPaymentMethodForApi('khalti'), 'online');
      expect(mapPaymentMethodForApi('cod'), 'cod');
      expect(mapPaymentMethodForApi('cash'), 'cod');
    });
  });
}
