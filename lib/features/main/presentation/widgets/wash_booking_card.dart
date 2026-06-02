import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../data/main_shell_mock_data.dart';
import 'wash_history_detail_row.dart';

/// Dev Handoff wash history list card (gray/50 container, key-value rows).
class WashBookingCard extends StatelessWidget {
  const WashBookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
  });

  final WashBookingMock booking;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
            Text(
              booking.station,
              style: AppTextStyles.textMdMedium.copyWith(
                color: AppColors.gray900,
              ),
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
            const SizedBox(height: 8),
            WashHistoryDetailRow(label: 'Status', value: booking.status),
            const SizedBox(height: 14),
            AppButton(
              label: 'View more details',
              variant: AppButtonVariant.secondary,
              onPressed: onViewDetails,
            ),
          ],
        ),
      ),
    );
  }
}
