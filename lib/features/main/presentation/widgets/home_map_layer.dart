import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/main_shell_mock_data.dart';

/// Map background for the Droplet home screen (Dev Handoff).
class HomeMapLayer extends StatelessWidget {
  const HomeMapLayer({
    super.key,
    required this.stations,
    this.latitude,
    this.longitude,
  });

  final List<WashStationMock> stations;
  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    final center = _resolveCenter();

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13.5,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.kauwatech.vwa',
        ),
        if (latitude != null && longitude != null)
          MarkerLayer(
            markers: [
              Marker(
                width: 32,
                height: 32,
                point: LatLng(latitude!, longitude!),
                child: const _UserLocationMarker(),
              ),
            ],
          ),
        if (stations.isNotEmpty)
          MarkerLayer(
            markers: [
              for (final station in stations)
                if (station.latitude != 0 || station.longitude != 0)
                  Marker(
                    width: 12,
                    height: 12,
                    point: LatLng(station.latitude, station.longitude),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF444CE7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
            ],
          ),
      ],
    );
  }

  LatLng _resolveCenter() {
    if (latitude != null && longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    if (stations.isNotEmpty) {
      final first = stations.first;
      if (first.latitude != 0 || first.longitude != 0) {
        return LatLng(first.latitude, first.longitude);
      }
    }
    return const LatLng(27.7172, 85.3240);
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1A73E8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const SizedBox.expand(),
    );
  }
}
