import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../shared/utils/map_navigation.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../../shared/widgets/app_logo_progress_indicator.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/profile_avatar.dart';
import '../../data/wash_station_repository.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../providers/home_provider.dart';
import '../providers/main_shell_provider.dart';
import '../widgets/home_filter_bottom_sheet.dart';
import '../widgets/home_filter_chips.dart';
import '../widgets/home_map_layer.dart';
import '../../../../shared/widgets/shimmers/station_card_shimmer.dart';
import '../widgets/station_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with WidgetsBindingObserver {
  late final HomeProvider _provider;
  UserProfileProvider? _profileProvider;
  bool _providerInitialized = false;
  bool _savedLocationSynced = false;
  bool _locationBootstrapStarted = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _onHomeTabReady());
  }

  void _onHomeTabReady() {
    if (!mounted) {
      return;
    }

    _attachProfileListener();
    _bootstrapLocation();
    _syncSavedLocationFromProfile();
  }

  void _attachProfileListener() {
    _profileProvider?.removeListener(_onProfileUpdated);
    _profileProvider = context.read<UserProfileProvider>();
    _profileProvider!.addListener(_onProfileUpdated);
  }

  void _onProfileUpdated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _syncSavedLocationFromProfile();
    });
  }

  void _bootstrapLocation() {
    if (_locationBootstrapStarted) {
      return;
    }

    final saved = _profileProvider?.profile?.primaryLocation;
    if (saved != null && saved.latitude != 0 && saved.longitude != 0) {
      _locationBootstrapStarted = true;
      _savedLocationSynced = true;
      _provider.applySavedLocation(
        latitude: saved.latitude,
        longitude: saved.longitude,
        address: saved.address,
      );
      _provider.loadStations();
      return;
    }

    _locationBootstrapStarted = true;
    _provider.resolveCurrentLocation(retryAfterDeny: true);
  }

  void _syncSavedLocationFromProfile() {
    if (_savedLocationSynced || !_providerInitialized) {
      return;
    }

    final saved = _profileProvider?.profile?.primaryLocation;
    if (saved == null || (saved.latitude == 0 && saved.longitude == 0)) {
      return;
    }

    _savedLocationSynced = true;
    if (!_locationBootstrapStarted) {
      _locationBootstrapStarted = true;
    }
    _provider.applySavedLocation(
      latitude: saved.latitude,
      longitude: saved.longitude,
      address: saved.address,
    );
    _provider.loadStations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _profileProvider?.removeListener(_onProfileUpdated);
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

  Future<void> _openFilterSheet(
    BuildContext context,
    HomeProvider provider,
  ) async {
    final selected = await showHomeFilterBottomSheet(
      context: context,
      selectedTab: provider.selectedStationTab,
    );
    if (selected != null && mounted) {
      await provider.setStationTab(selected);
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

          return Stack(
            fit: StackFit.expand,
            children: [
              HomeMapLayer(
                stations: provider.visibleStations,
                latitude: provider.latitude,
                longitude: provider.longitude,
              ),
              Column(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: AppColors.homeDropletGradient,
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.sm,
                              AppSpacing.lg,
                              AppSpacing.sm,
                            ),
                            child: _HomeHeader(
                              currentLocation: provider.currentLocation,
                              isResolvingLocation: provider.isResolvingLocation,
                              onSearch: () =>
                                  navigateToStationSearchMap(context),
                              onNotifications: () => AppToast.showNeutral(
                                context,
                                'Notifications will appear here soon.',
                              ),
                            ),
                          ),
                          HomeFilterChips(
                            selectedTab: provider.selectedStationTab,
                            onTabChanged: provider.setStationTab,
                            onFilterTap: () =>
                                _openFilterSheet(context, provider),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.lg),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.xxl,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                              ),
                              child: Text(
                                provider.sectionTitle,
                                style: AppTextStyles.displayXsSemiBold.copyWith(
                                  color: AppColors.gray950,
                                  height: 30 / 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Expanded(
                              child: _StationListBody(provider: provider),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

class _StationListBody extends StatelessWidget {
  const _StationListBody({required this.provider});

  final HomeProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.brand500,
      onRefresh: provider.refreshForCurrentTab,
      child: _StationListScrollable(provider: provider),
    );
  }
}

class _StationListScrollable extends StatelessWidget {
  const _StationListScrollable({required this.provider});

  final HomeProvider provider;

  static const _shimmerCount = 4;

  @override
  Widget build(BuildContext context) {
    final isLoading = provider.isLoadingStations;
    final stations = provider.visibleStations;

    if (!isLoading && stations.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: AppSpacing.xxxl),
            children: [
              SizedBox(
                height: constraints.maxHeight - AppSpacing.xxxl,
                child: Center(
                  child: Text(
                    provider.emptyStateMessage,
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    final itemCount = isLoading ? _shimmerCount : stations.length;

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 17),
      itemBuilder: (context, index) {
        if (isLoading) {
          return const StationCardShimmer();
        }

        final station = stations[index];
        return StationCard(
          station: station,
          onTap: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.stationDetail, arguments: station),
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.currentLocation,
    required this.isResolvingLocation,
    required this.onSearch,
    required this.onNotifications,
  });

  final String currentLocation;
  final bool isResolvingLocation;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    final displayName = profileProvider.displayName;
    final avatarUrl = profileProvider.avatarUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.read<MainShellProvider>().setTab(2),
              child: ClipOval(
                child: ProfileAvatar(avatarUrl: avatarUrl, size: 50),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GestureDetector(
                onTap: () => context.read<MainShellProvider>().setTab(2),
                behavior: HitTestBehavior.opaque,
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
                      displayName,
                      style: AppTextStyles.textXlSemiBold.copyWith(
                        color: AppColors.white,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
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
              onPressed: onNotifications,
              icon: const AppSvgIcon(
                AppSvgIconName.notification,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        DecoratedBox(
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
      ],
    );
  }
}
