import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_assets.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flow_modal.dart';
import '../../../../shared/utils/map_navigation.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/shimmers/station_detail_shimmer.dart';
import '../providers/saved_stations_provider.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../../booking/presentation/providers/wash_bookings_provider.dart';
import '../../data/booking_flow_mock_data.dart';
import '../../data/main_shell_mock_data.dart';
import '../../data/wash_station_repository.dart';
import '../widgets/booking_summary_bottom_sheet.dart';
import '../widgets/select_vehicle_bottom_sheet.dart';

class StationDetailScreen extends StatefulWidget {
  const StationDetailScreen({super.key, required this.station});

  final WashStationMock station;

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  late WashStationMock _station;
  var _isLoadingDetail = false;
  var _isCreatingBooking = false;
  var _isSaved = false;
  var _isTogglingSave = false;

  @override
  void initState() {
    super.initState();
    _station = widget.station;
    _loadStationDetail();
    _refreshSavedState();
  }

  Future<void> _refreshSavedState() async {
    final saved = await context.read<SavedStationsProvider>().isSaved(
      _station.id,
    );
    if (mounted) {
      setState(() => _isSaved = saved);
    }
  }

  Future<void> _toggleSaved() async {
    if (_isTogglingSave) {
      return;
    }

    setState(() => _isTogglingSave = true);
    final isSaved = await context.read<SavedStationsProvider>().toggleStation(
      _station,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isSaved = isSaved;
      _isTogglingSave = false;
    });
    AppToast.showSuccess(
      context,
      isSaved ? 'Station saved to your list.' : 'Station removed from saved.',
    );
  }

  Future<void> _loadStationDetail() async {
    if (_station.id.isEmpty) {
      return;
    }

    setState(() => _isLoadingDetail = true);
    final updated = await context
        .read<WashStationRepository>()
        .fetchStationDetail(_station.id);
    if (!mounted) {
      return;
    }

    if (updated != null) {
      _station = updated;
    }
    setState(() => _isLoadingDetail = false);
    await _refreshSavedState();
  }

  Future<void> _handleBookSlot() async {
    final vehicle = await showSelectVehicleBottomSheet(context: context);
    if (vehicle == null || !mounted) {
      return;
    }

    final shouldBook = await showAppFlowModal(
      context: context,
      message: 'Are you sure you want to book a slot?',
    );

    if (!shouldBook || !mounted) {
      return;
    }

    final draft = bookingDraftForStation(station: _station, vehicle: vehicle);
    final confirmed = await showBookingSummaryBottomSheet(
      context: context,
      draft: draft,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _isCreatingBooking = true);
    final result = await context.read<BookingRepository>().createBooking(draft);
    if (!mounted) {
      return;
    }
    setState(() => _isCreatingBooking = false);

    await result.fold(
      (failure) async {
        AppToast.showError(context, failure.message);
      },
      (booking) async {
        AppToast.showSuccess(context, 'Booking created successfully.');
        context.read<WashBookingsProvider>().loadBookings();
        await Navigator.of(context).pushNamed(
          AppRoutes.bookingSuccess,
          arguments: draft.copyWith(bookingId: booking.id),
        );
      },
    );
  }

  List<String> get _serviceItems => _station.serviceNames;

  List<String> get _operatingHourItems => _station.operatingHours;

  Future<void> _openDirections() async {
    final opened = await openGoogleMapsForStation(
      latitude: _station.latitude,
      longitude: _station.longitude,
      label: _station.name,
    );
    if (!mounted) {
      return;
    }
    if (!opened) {
      AppToast.showError(
        context,
        'Could not open maps. Station location may be unavailable.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Stack(
            children: [
              if (_isLoadingDetail)
                const StationDetailShimmer()
              else
                Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: _StationHero(
                              station: _station,
                              isSaved: _isSaved,
                              onBookmark: _toggleSaved,
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.xxl,
                              AppSpacing.lg,
                              AppSpacing.xxxl,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                _StationSummaryCard(station: _station),
                                if (_serviceItems.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.lg),
                                  _InfoSectionCard(
                                    title: 'Services Offered',
                                    items: _serviceItems,
                                  ),
                                ],
                                if (_operatingHourItems.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.lg),
                                  _InfoSectionCard(
                                    title: 'Operating hour',
                                    items: _operatingHourItems,
                                    icon: AppSvgIconName.clock,
                                  ),
                                ],
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StationActionBar(
                      onBookSlot: _handleBookSlot,
                      onGetDirection: _openDirections,
                    ),
                  ],
                ),
              if (_isCreatingBooking) const AppLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationHero extends StatelessWidget {
  const _StationHero({
    required this.station,
    required this.isSaved,
    required this.onBookmark,
  });

  final WashStationMock station;
  final bool isSaved;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 277,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.stationBikeWash, fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FloatingIconButton(
                    icon: AppSvgIconName.arrowLeft,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  _FloatingIconButton(
                    icon: AppSvgIconName.bookmark,
                    iconColor: isSaved ? AppColors.brand500 : AppColors.white,
                    onPressed: onBookmark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  const _FloatingIconButton({
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.white,
  });

  final AppSvgIconName icon;
  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.gray800,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(child: AppSvgIcon(icon, color: iconColor, size: 20)),
        ),
      ),
    );
  }
}

class _StationSummaryCard extends StatelessWidget {
  const _StationSummaryCard({required this.station});

  final WashStationMock station;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray50,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140D121C),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: AppTextStyles.displayXsSemiBold.copyWith(
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const AppSvgIcon(
                  AppSvgIconName.location,
                  size: 16,
                  color: AppColors.gray600,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '${station.location} • ${station.distance}',
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const AppSvgIcon(
                  AppSvgIconName.star,
                  size: 16,
                  color: Color(0xFFFEC84B),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  station.rating,
                  style: AppTextStyles.textSmRegular.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppProfileRoutes.reviews),
                  child: Text(
                    '(${station.reviewCount} reviews)',
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.blue600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    backgroundColor: AppColors.blue50,
                    value: station.price,
                    label: 'Price',
                    valueColor: AppColors.blue700,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _MetricTile(
                    backgroundColor: AppColors.green50,
                    value: '${station.availableSlotsCount}',
                    label: 'Available Slots',
                    valueColor: AppColors.green600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.backgroundColor,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final Color backgroundColor;
  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.displayXsSemiBold.copyWith(
                color: valueColor,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.textSmRegular.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  const _InfoSectionCard({
    required this.title,
    required this.items,
    this.icon = AppSvgIconName.wash,
  });

  final String title;
  final List<String> items;
  final AppSvgIconName icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray50,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140D121C),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.textXlSemiBold.copyWith(
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final item in items) ...[
              _ServiceRow(label: item, icon: icon),
              if (item != items.last) const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.label, required this.icon});

  final String label;
  final AppSvgIconName icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.green100,
            borderRadius: BorderRadius.circular(6.8),
          ),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: AppSvgIcon(icon, color: AppColors.green700, size: 18),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.textMdRegular.copyWith(
              color: AppColors.gray700,
            ),
          ),
        ),
      ],
    );
  }
}

class _StationActionBar extends StatelessWidget {
  const _StationActionBar({
    required this.onBookSlot,
    required this.onGetDirection,
  });

  final VoidCallback onBookSlot;
  final VoidCallback onGetDirection;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray200, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Book a slot',
                  variant: AppButtonVariant.secondary,
                  onPressed: onBookSlot,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: 'Get Direction',
                  onPressed: onGetDirection,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
