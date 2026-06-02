import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_routes.dart';

/// Opens the Dev Handoff Search flow map screen.
void navigateToStationSearchMap(BuildContext context) {
  Navigator.of(context).pushNamed(AppRoutes.stationSearchMap);
}

/// Guard for any direct route name usage.
bool isMapRoute(String? routeName) => routeName == AppRoutes.stationSearchMap;

/// Opens the station location in Google Maps (external app or browser).
Future<bool> openGoogleMapsForStation({
  required double latitude,
  required double longitude,
  String? label,
}) async {
  if (latitude == 0 && longitude == 0) {
    return false;
  }

  final query = label == null || label.trim().isEmpty
      ? '$latitude,$longitude'
      : '$latitude,$longitude (${Uri.encodeComponent(label.trim())})';

  final googleMapsUri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$query',
  );

  if (await canLaunchUrl(googleMapsUri)) {
    return launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
  }

  final geoUri = Uri.parse('geo:$latitude,$longitude?q=$query');
  if (await canLaunchUrl(geoUri)) {
    return launchUrl(geoUri, mode: LaunchMode.externalApplication);
  }

  return false;
}
