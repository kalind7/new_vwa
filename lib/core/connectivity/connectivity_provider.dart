import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'connectivity_status.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_applyResults);
    unawaited(_refresh());
  }

  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOnline = true;
  bool _isDisposed = false;

  bool get isOnline => _isOnline;

  Future<void> recheck() => _refresh();

  Future<void> _refresh() async {
    final results = await _connectivity.checkConnectivity();
    _applyResults(results);
  }

  void _applyResults(List<ConnectivityResult> results) {
    final online = isConnectivityOnline(results);
    if (online == _isOnline || _isDisposed) {
      return;
    }
    _isOnline = online;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
