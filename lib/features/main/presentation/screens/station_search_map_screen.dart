import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
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
  StationSearchProvider? _provider;
  bool _providerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_providerInitialized) {
      return;
    }
    _providerInitialized = true;
    _provider = StationSearchProvider(
      stationRepository: context.read<WashStationRepository>(),
    )..loadStations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _provider?.dispose();
    super.dispose();
  }

  void _selectStation(WashStationMock station) {
    FocusScope.of(context).unfocus();
    _mapController.move(LatLng(station.latitude, station.longitude), 16);
    _searchController.text = station.name;
    _provider?.selectStation(station);
  }

  void _openStationDetail(WashStationMock station) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.stationDetail, arguments: station);
  }

  @override
  Widget build(BuildContext context) {
    final provider = _provider;
    if (provider == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider<StationSearchProvider>.value(
      value: provider,
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
                    child: _SelectedStationPreviewSheet(
                      station: provider.selectedStation!,
                      onClose: provider.clearMapSelection,
                      onTap: () =>
                          _openStationDetail(provider.selectedStation!),
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
    return Row(
      children: [
        Material(
          color: AppColors.gray800,
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.gray25, width: 0.86),
          ),
          child: InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: AppSvgIcon(
                  AppSvgIconName.arrowLeft,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.gray300),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D101828),
                  blurRadius: 2,
                  offset: Offset(0, 1),
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
                suffixIcon: const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: AppSvgIcon(
                    AppSvgIconName.search,
                    color: AppColors.gray500,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ),
      ],
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
                    leading: const AppSvgIcon(
                      AppSvgIconName.wash,
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
      child: AppSvgIcon(
        AppSvgIconName.location,
        color: isSelected ? AppColors.brand500 : AppColors.indigo600,
        size: isSelected ? 48 : 40,
      ),
    );
  }
}

class _SelectedStationPreviewSheet extends StatelessWidget {
  const _SelectedStationPreviewSheet({
    required this.station,
    required this.onTap,
    required this.onClose,
  });

  final WashStationMock station;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.gray50,
        border: Border(top: BorderSide(color: AppColors.gray200)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A101828),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xxl,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: const AppSvgIcon(
                    AppSvgIconName.close,
                    color: AppColors.gray700,
                    size: 20,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
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
                                style: AppTextStyles.textSmRegular.copyWith(
                                  color: AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const AppSvgIcon(
                          AppSvgIconName.chevronRight,
                          color: AppColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  _MapMetaChip(
                    icon: AppSvgIconName.star,
                    label: station.rating,
                    color: const Color(0xFFFEC84B),
                  ),
                  _MapMetaChip(
                    icon: AppSvgIconName.route,
                    label: station.distance,
                    color: AppColors.gray700,
                  ),
                  _MapMetaChip(
                    icon: AppSvgIconName.clock,
                    label: station.slots,
                    color: AppColors.brand500,
                  ),
                ],
              ),
            ],
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

  final AppSvgIconName icon;
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
            AppSvgIcon(icon, color: color, size: 16),
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
