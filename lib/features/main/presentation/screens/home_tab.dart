import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_assets.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../data/wash_station_repository.dart';
import '../providers/home_provider.dart';
import '../widgets/station_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with WidgetsBindingObserver {
  late final HomeProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = HomeProvider(
      stationRepository: const MockWashStationRepository(),
    );
    _provider
      ..loadStations()
      ..resolveCurrentLocation(retryAfterDeny: true);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _provider.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _provider.resolveCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>.value(
      value: _provider,
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.shouldShowSettingsPrompt) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _showLocationSettingsDialog(context, provider);
              }
            });
          }
          final visibleStations = provider.visibleStations;

          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  AppColors.homeGradientStart,
                  AppColors.homeGradientEnd,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.xxl,
                        AppSpacing.xl,
                        AppSpacing.xxl,
                      ),
                      child: _HomeHeader(
                        currentLocation: provider.currentLocation,
                        isResolvingLocation: provider.isResolvingLocation,
                        onSearch: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.stationSearchMap),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(color: AppColors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xl,
                          AppSpacing.lg,
                          AppSpacing.xl,
                          AppSpacing.xxl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StationSectionHeader(
                              selectedTab: provider.selectedStationTab,
                              onTabChanged: provider.setStationTab,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Expanded(
                              child: provider.isLoadingStations
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemCount: visibleStations.length,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(
                                            height: AppSpacing.xxl,
                                          ),
                                      itemBuilder: (context, index) {
                                        final station = visibleStations[index];
                                        return StationCard(
                                          station: station,
                                          onTap: () =>
                                              Navigator.of(context).pushNamed(
                                                AppRoutes.stationDetail,
                                                arguments: station,
                                              ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showLocationSettingsDialog(
    BuildContext context,
    HomeProvider provider,
  ) async {
    provider.clearSettingsPrompt();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location permission needed'),
          content: const Text(
            'Please allow location access so nearby washing stations can use '
            'your current location.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Not now'),
            ),
            TextButton(
              onPressed: () {
                provider.openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Open settings'),
            ),
          ],
        );
      },
    );
  }
}

class _StationSectionHeader extends StatelessWidget {
  const _StationSectionHeader({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final HomeStationTab selectedTab;
  final ValueChanged<HomeStationTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _StationTabChip(
                label: 'Nearby Station',
                isSelected: selectedTab == HomeStationTab.nearby,
                onTap: () => onTabChanged(HomeStationTab.nearby),
              ),
              _StationTabChip(
                label: 'Less distance',
                isSelected: selectedTab == HomeStationTab.lessDistance,
                onTap: () => onTabChanged(HomeStationTab.lessDistance),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Filters open in a later phase.')),
          ),
          icon: const Icon(Icons.tune_rounded, color: AppColors.gray900),
        ),
      ],
    );
  }
}

class _StationTabChip extends StatelessWidget {
  const _StationTabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.gray900,
      backgroundColor: AppColors.white,
      side: BorderSide(
        color: isSelected ? AppColors.gray900 : AppColors.gray200,
      ),
      labelStyle: AppTextStyles.textSmMedium.copyWith(
        color: isSelected ? AppColors.white : AppColors.gray700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.currentLocation,
    required this.isResolvingLocation,
    required this.onSearch,
  });

  final String currentLocation;
  final bool isResolvingLocation;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                AppAssets.homeAvatar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello',
                    style: AppTextStyles.textMdRegular.copyWith(
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Ankit Shrestha',
                    style: AppTextStyles.textXlSemiBold.copyWith(
                      color: AppColors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded, color: AppColors.white),
            ),
            IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications open in a later phase.'),
                ),
              ),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - (AppSpacing.xl * 2),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.white,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      currentLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textXsMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  if (isResolvingLocation) ...[
                    const SizedBox(width: AppSpacing.xs),
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
