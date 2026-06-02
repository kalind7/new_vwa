import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_assets.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flow_modal.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../data/booking_flow_mock_data.dart';
import '../../data/main_shell_mock_data.dart';
import '../widgets/select_vehicle_bottom_sheet.dart';

class StationDetailScreen extends StatelessWidget {
  const StationDetailScreen({super.key, required this.station});

  final WashStationMock station;

  Future<void> _handleBookSlot(BuildContext context) async {
    final vehicle = await showSelectVehicleBottomSheet(context: context);
    if (vehicle == null || !context.mounted) {
      return;
    }

    final shouldBook = await showAppFlowModal(
      context: context,
      messageLines: const ['Are you sure you want ', 'book a slot?'],
    );

    if (!shouldBook || !context.mounted) {
      return;
    }

    await Navigator.of(context).pushNamed(
      AppRoutes.bookingSuccess,
      arguments: bookingDraftForStation(station: station, vehicle: vehicle),
    );
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
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _StationHero(station: station),
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
                          _StationSummaryCard(station: station),
                          const SizedBox(height: AppSpacing.lg),
                          _InfoSectionCard(
                            title: 'Services Offered',
                            items: stationServices,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _InfoSectionCard(
                            title: 'Operating hour',
                            items: stationServices,
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              _StationActionBar(
                onBookSlot: () => _handleBookSlot(context),
                onGetDirection: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening directions.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationHero extends StatelessWidget {
  const _StationHero({required this.station});

  final WashStationMock station;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
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
                    onPressed: () {},
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
  const _FloatingIconButton({required this.icon, required this.onPressed});

  final AppSvgIconName icon;
  final VoidCallback onPressed;

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
          child: Center(
            child: AppSvgIcon(icon, color: AppColors.white, size: 20),
          ),
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
                  onTap: () => Navigator.of(context).pushNamed(
                    AppProfileRoutes.reviews,
                  ),
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
  const _InfoSectionCard({required this.title, required this.items});

  final String title;
  final List<String> items;

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
              _ServiceRow(label: item),
              if (item != items.last) const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.green100,
            borderRadius: BorderRadius.circular(6.8),
          ),
          child: const SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: AppSvgIcon(
                AppSvgIconName.wash,
                color: AppColors.green700,
                size: 18,
              ),
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