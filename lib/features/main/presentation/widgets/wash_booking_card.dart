import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../data/main_shell_mock_data.dart';
import 'wash_history_detail_row.dart';

/// Dev Handoff wash history list card (gray/50 container, key-value rows).
class WashBookingCard extends StatelessWidget {
  const WashBookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  final WashBookingMock booking;
  final VoidCallback onTap;

  Color get _statusColor {
    return switch (booking.status) {
      'Washing' => AppColors.blue600,
      'Completed' => AppColors.green600,
      'Cancelled' => AppColors.gray500,
      _ => AppColors.brand500,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.gray200),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.station,
                        style: AppTextStyles.textMdMedium.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: Text(
                          booking.status,
                          style: AppTextStyles.textXsMedium.copyWith(
                            color: _statusColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                WashHistoryDetailRow(label: 'Location', value: booking.location),
                const SizedBox(height: 8),
                WashHistoryDetailRow(
                  label: 'Vehicle number',
                  value: booking.vehicle,
                ),
                const SizedBox(height: 8),
                WashHistoryDetailRow(label: 'Total', value: booking.price),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
