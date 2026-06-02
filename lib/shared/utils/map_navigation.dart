import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../widgets/app_toast.dart';

/// Map screen is disabled during static UI phase — show a toast instead.
void navigateToStationSearchMap(BuildContext context) {
  AppToast.showNeutral(context, 'Map view is coming soon.');
}

/// Route builder placeholder while [StationSearchMapScreen] is disabled.
Widget buildDisabledMapRoute(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) {
      return;
    }
    navigateToStationSearchMap(context);
    Navigator.of(context).maybePop();
  });
  return const Scaffold(
    body: SizedBox.shrink(),
  );
}

/// Guard for any direct route name usage.
bool isMapRoute(String? routeName) => routeName == AppRoutes.stationSearchMap;
