import 'package:connectivity_plus/connectivity_plus.dart';

/// True when at least one active network interface is available.
bool isConnectivityOnline(List<ConnectivityResult> results) {
  return results.any((result) => result != ConnectivityResult.none);
}
