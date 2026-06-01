import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../data/main_shell_mock_data.dart';

class WashBookingCard extends StatelessWidget {
  const WashBookingCard({
    super.key,
    required this.booking,
    required this.onCancel,
  });

  final WashBookingMock booking;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isComplete = booking.status == 'Completed';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.gray200),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F101828),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    Icons.water_drop_outlined,
                    color: isComplete
                        ? AppColors.success100
                        : AppColors.indigo600,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.station,
                        style: AppTextStyles.textMdSemiBold.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        booking.service,
                        style: AppTextStyles.textSmRegular.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusPill(label: booking.status, isComplete: isComplete),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _BookingInfoRow(
              icon: Icons.calendar_today_outlined,
              text: booking.date,
            ),
            const SizedBox(height: AppSpacing.sm),
            _BookingInfoRow(
              icon: Icons.access_time_rounded,
              text: booking.time,
            ),
            const SizedBox(height: AppSpacing.sm),
            _BookingInfoRow(
              icon: Icons.two_wheeler_rounded,
              text: booking.vehicle,
            ),
            if (booking.canCancel) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Cancel booking',
                variant: AppButtonVariant.secondary,
                onPressed: onCancel,
              ),
            ] else ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Bike wash has been completed',
                style: AppTextStyles.textSmMedium.copyWith(
                  color: AppColors.success100,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.isComplete});

  final String label;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isComplete ? AppColors.success50 : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: AppTextStyles.textXsMedium.copyWith(
            color: isComplete ? AppColors.gray700 : AppColors.indigo600,
          ),
        ),
      ),
    );
  }
}

class _BookingInfoRow extends StatelessWidget {
  const _BookingInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gray500, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: AppTextStyles.textSmMedium.copyWith(color: AppColors.gray700),
        ),
      ],
    );
  }
}
