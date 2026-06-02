import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../shared/utils/map_navigation.dart';
import '../../../../config/app_assets.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../../shared/widgets/app_logo_progress_indicator.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_toast.dart';
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
  bool _providerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_providerInitialized) {
      return;
    }
    _providerInitialized = true;
    _provider = HomeProvider(
      stationRepository: context.read<WashStationRepository>(),
    );
    _provider.resolveCurrentLocation(retryAfterDeny: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_providerInitialized) {
      _provider.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _providerInitialized) {
      _provider.resolveCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_providerInitialized) {
      return const SizedBox.shrink();
    }

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
                        onSearch: () => navigateToStationSearchMap(context),
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
                                      child: AppLogoProgressIndicator(
                                        size: 56,
                                      ),
                                    )
                                  : visibleStations.isEmpty
                                  ? Center(
                                      child: Text(
                                        provider.emptyStateMessage,
                                        style: AppTextStyles.textSmRegular
                                            .copyWith(
                                              color: AppColors.gray500,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
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
    final shouldOpenSettings = await showAppConfirmationDialog(
      context: context,
      title: 'Location permission needed',
      message:
          'Please allow location access so nearby washing stations can use '
          'your current location.',
      confirmLabel: 'Open settings',
      cancelLabel: 'Not now',
    );

    if (shouldOpenSettings) {
      await provider.openAppSettings();
    }
  }
}

class _StationSectionHeader extends StatelessWidget {
  const _StationSectionHeader({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final HomeStationTab selectedTab;
  final Future<void> Function(HomeStationTab tab) onTabChanged;

  static const _tabs = [
    (HomeStationTab.nearby, 'Nearby'),
    (HomeStationTab.lessDistance, 'Less distance'),
    (HomeStationTab.all, 'All'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < _tabs.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _StationTabChip(
              label: _tabs[index].$2,
              isSelected: selectedTab == _tabs[index].$1,
              onTap: () => onTabChanged(_tabs[index].$1),
            ),
          ),
        ],
        IconButton(
          onPressed: () => AppToast.showNeutral(
            context,
            'Filters open in a later phase.',
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          icon: const AppSvgIcon(
            AppSvgIconName.filter,
            color: AppColors.gray900,
          ),
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
    return Material(
      color: isSelected ? AppColors.gray900 : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        side: BorderSide(
          color: isSelected ? AppColors.gray900 : AppColors.gray200,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textXsMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.gray700,
              ),
            ),
          ),
        ),
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
              icon: const AppSvgIcon(
                AppSvgIconName.search,
                color: AppColors.white,
              ),
            ),
            IconButton(
              onPressed: () => AppToast.showNeutral(
                context,
                'Notifications open in a later phase.',
              ),
              icon: const AppSvgIcon(
                AppSvgIconName.notification,
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
                  const AppSvgIcon(
                    AppSvgIconName.location,
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
                    const AppLogoProgressIndicator(
                      size: 18,
                      progressColor: AppColors.white,
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
