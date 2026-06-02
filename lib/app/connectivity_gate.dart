import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/connectivity/connectivity_provider.dart';
import '../shared/screens/no_internet_screen.dart';

/// Shows [NoInternetScreen] over the app when no network interface is available.
class ConnectivityGate extends StatelessWidget {
  const ConnectivityGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (!isOnline) const Positioned.fill(child: NoInternetScreen()),
      ],
    );
  }
}
