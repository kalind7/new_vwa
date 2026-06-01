import 'package:flutter/material.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../data/main_shell_mock_data.dart';

class StationDetailScreen extends StatelessWidget {
  const StationDetailScreen({super.key, required this.station});

  final WashStationMock station;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.gray900,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                AppAssets.stationBikeWash,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppColors.gray700,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        station.location,
                        style: AppTextStyles.textSmRegular.copyWith(
                          color: AppColors.gray700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      _DetailChip(
                        icon: Icons.star_rounded,
                        label: station.rating,
                        color: const Color(0xFFFEC84B),
                      ),
                      _DetailChip(
                        icon: Icons.route_outlined,
                        label: station.distance,
                        color: AppColors.gray700,
                      ),
                      _DetailChip(
                        icon: Icons.payments_outlined,
                        label: station.price,
                        color: AppColors.gray700,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Text(
                    'Services Offered',
                    style: AppTextStyles.textXlSemiBold.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _ServiceTile(title: 'Exterior Wash', price: 'Nrs 100'),
                  const SizedBox(height: AppSpacing.md),
                  const _ServiceTile(title: 'Full Bike Wash', price: 'Nrs 150'),
                  const SizedBox(height: AppSpacing.xxxl),
                  AppButton(
                    label: 'Book a slot',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Booking flow starts in the next phase.'),
                      ),
                    ),
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

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: AppColors.gray50,
      side: const BorderSide(color: AppColors.gray200),
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label),
      labelStyle: AppTextStyles.textXsMedium.copyWith(color: AppColors.gray900),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            const Icon(
              Icons.local_car_wash_outlined,
              color: AppColors.brand500,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.textMdSemiBold.copyWith(
                  color: AppColors.gray900,
                ),
              ),
            ),
            Text(
              price,
              style: AppTextStyles.textSmMedium.copyWith(
                color: AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
