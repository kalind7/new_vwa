import 'package:flutter/material.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../data/main_shell_mock_data.dart';

class StationCard extends StatelessWidget {
  const StationCard({super.key, required this.station, required this.onTap});

  final WashStationMock station;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: Image.asset(
                AppAssets.stationBikeWash,
                width: double.infinity,
                height: 166,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              station.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textXlSemiBold.copyWith(
                color: AppColors.gray900,
                height: 1.15,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const AppSvgIcon(
                  AppSvgIconName.location,
                  size: 18,
                  color: AppColors.gray900,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    station.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppSvgIcon(
                      AppSvgIconName.star,
                      color: Color(0xFFFEC84B),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      station.rating,
                      style: AppTextStyles.textSmRegular.copyWith(
                        color: AppColors.gray900,
                      ),
                    ),
                  ],
                ),
                Text(
                  station.distance,
                  style: AppTextStyles.textSmRegular.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _GreenDot(),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      station.price,
                      style: AppTextStyles.textSmRegular.copyWith(
                        color: AppColors.gray900,
                      ),
                    ),
                  ],
                ),
                _SlotsPill(station: station),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GreenDot extends StatelessWidget {
  const _GreenDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFF12B76A),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SlotsPill extends StatelessWidget {
  const _SlotsPill({required this.station});

  final WashStationMock station;

  @override
  Widget build(BuildContext context) {
    final isHighAvailability = station.slots.startsWith('25');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: station.slotsColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          station.slots,
          style: AppTextStyles.textXsMedium.copyWith(
            color: isHighAvailability
                ? const Color(0xFF027A48)
                : const Color(0xFFB54708),
          ),
        ),
      ),
    );
  }
}
