import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vwa/core/connectivity/connectivity_status.dart';

void main() {
  group('isConnectivityOnline', () {
    test('returns false when only none', () {
      expect(isConnectivityOnline([ConnectivityResult.none]), isFalse);
    });

    test('returns true when wifi is available', () {
      expect(
        isConnectivityOnline([
          ConnectivityResult.none,
          ConnectivityResult.wifi,
        ]),
        isTrue,
      );
    });

    test('returns true for mobile', () {
      expect(isConnectivityOnline([ConnectivityResult.mobile]), isTrue);
    });
  });
}
