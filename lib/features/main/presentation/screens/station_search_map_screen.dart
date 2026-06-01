import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../data/main_shell_mock_data.dart';
import '../../data/wash_station_repository.dart';
import '../providers/station_search_provider.dart';

class StationSearchMapScreen extends StatefulWidget {
  const StationSearchMapScreen({super.key});

  @override
  State<StationSearchMapScreen> createState() => _StationSearchMapScreenState();
}

class _StationSearchMapScreenState extends State<StationSearchMapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  late final StationSearchProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = StationSearchProvider(
      stationRepository: const MockWashStationRepository(),
    )..loadStations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _provider.dispose();
    super.dispose();
  }

  void _selectStation(WashStationMock station) {
    FocusScope.of(context).unfocus();
    _mapController.move(LatLng(station.latitude, station.longitude), 16);
    _searchController.text = station.name;
    _provider.selectStation(station);
  }

  void _openStationDetail(WashStationMock station) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.stationDetail, arguments: station);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StationSearchProvider>.value(
      value: _provider,
      child: Consumer<StationSearchProvider>(
        builder: (context, provider, _) {
          final stations = provider.stations.isNotEmpty
              ? provider.stations
              : nearbyStations;

          return Scaffold(
            backgroundColor: AppColors.white,
            body: Stack(
              children: [
                Positioned.fill(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: provider.initialCenter,
                      initialZoom: 14,
                      onTap: (_, _) {
                        FocusScope.of(context).unfocus();
                        provider.clearMapSelection();
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.kauwatech.vwa',
                      ),
                      MarkerLayer(
                        markers: [
                          for (final station in stations)
                            Marker(
                              width: 56,
                              height: 56,
                              point: LatLng(
                                station.latitude,
                                station.longitude,
                              ),
                              child: _StationMarker(
                                isSelected: station == provider.selectedStation,
                                onTap: () => _selectStation(station),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SearchBar(
                          controller: _searchController,
                          onBack: () => Navigator.of(context).maybePop(),
                          onChanged: provider.updateQuery,
                          onTap: provider.showSearch,
                        ),
                        if (provider.showSearchResults) ...[
                          const SizedBox(height: AppSpacing.md),
                          _SearchResultsPanel(
                            stations: provider.filteredStations,
                            hasQuery: provider.query.trim().isNotEmpty,
                            onStationTap: _selectStation,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (provider.selectedStation != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      minimum: const EdgeInsets.all(AppSpacing.lg),
                      child: _SelectedStationSheet(
                        station: provider.selectedStation!,
                        onTap: () =>
                            _openStationDetail(provider.selectedStation!),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onBack,
    required this.onChanged,
    required this.onTap,
  });

  final TextEditingController controller;
  final VoidCallback onBack;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A101828),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search stations',
          hintStyle: AppTextStyles.textSmMedium.copyWith(
            color: AppColors.gray400,
          ),
          border: InputBorder.none,
          prefixIcon: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.gray700,
          ),
          suffixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.gray500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}

class _SearchResultsPanel extends StatelessWidget {
  const _SearchResultsPanel({
    required this.stations,
    required this.hasQuery,
    required this.onStationTap,
  });

  final List<WashStationMock> stations;
  final bool hasQuery;
  final ValueChanged<WashStationMock> onStationTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A101828),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 250),
        child: stations.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  hasQuery
                      ? 'No nearby station found for this search.'
                      : 'Type a station or area name to search.',
                  style: AppTextStyles.textSmRegular.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: stations.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.gray100),
                itemBuilder: (context, index) {
                  final station = stations[index];
                  return ListTile(
                    onTap: () => onStationTap(station),
                    leading: const Icon(
                      Icons.local_car_wash_outlined,
                      color: AppColors.brand500,
                    ),
                    title: Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textSmMedium.copyWith(
                        color: AppColors.gray900,
                      ),
                    ),
                    subtitle: Text(
                      station.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textXsMedium.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _StationMarker extends StatelessWidget {
  const _StationMarker({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.location_on_rounded,
        color: isSelected ? AppColors.brand500 : AppColors.indigo600,
        size: isSelected ? 48 : 40,
      ),
    );
  }
}

class _SelectedStationSheet extends StatelessWidget {
  const _SelectedStationSheet({required this.station, required this.onTap});

  final WashStationMock station;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: const [
              BoxShadow(
                color: Color(0x24101828),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.brand500.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Icon(
                          Icons.local_car_wash_outlined,
                          color: AppColors.brand500,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.textMdSemiBold.copyWith(
                              color: AppColors.gray900,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            station.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.textXsMedium.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.gray500,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _MapMetaChip(
                      icon: Icons.star_rounded,
                      label: station.rating,
                      color: const Color(0xFFFEC84B),
                    ),
                    _MapMetaChip(
                      icon: Icons.route_outlined,
                      label: station.distance,
                      color: AppColors.gray700,
                    ),
                    _MapMetaChip(
                      icon: Icons.schedule_rounded,
                      label: station.slots,
                      color: AppColors.brand500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapMetaChip extends StatelessWidget {
  const _MapMetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.textXsMedium.copyWith(
                color: AppColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
