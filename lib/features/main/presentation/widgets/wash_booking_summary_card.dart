import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_text_styles.dart';
import 'wash_history_detail_row.dart';

/// Gray/50 summary card used on wash detail and booking summary sheet.
class WashBookingSummaryCard extends StatelessWidget {
  const WashBookingSummaryCard({
    super.key,
    required this.stationName,
    required this.vehicleNumber,
    required this.total,
    this.location,
    this.date,
    this.paidVia,
    this.status,
    this.title,
  });

  final String stationName;
  final String vehicleNumber;
  final String total;
  final String? location;
  final String? date;
  final String? paidVia;
  final String? status;
  final String? title;

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
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.textMdMedium.copyWith(
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 14),
            ] else ...[
              Text(
                stationName,
                style: AppTextStyles.textMdMedium.copyWith(
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (title != null)
              WashHistoryDetailRow(label: 'Station', value: stationName),
            if (location != null) ...[
              const SizedBox(height: 8),
              WashHistoryDetailRow(label: 'Location', value: location!),
            ],
            if (date != null) ...[
              const SizedBox(height: 8),
              WashHistoryDetailRow(label: 'Date', value: date!),
            ],
            const SizedBox(height: 8),
            WashHistoryDetailRow(label: 'Vehicle number', value: vehicleNumber),
            if (paidVia != null) ...[
              const SizedBox(height: 8),
              WashHistoryDetailRow(label: 'Paid via', value: paidVia!),
            ],
            const SizedBox(height: 8),
            WashHistoryDetailRow(label: 'Total', value: total),
            if (status != null) ...[
              const SizedBox(height: 8),
              WashHistoryDetailRow(label: 'Status', value: status!),
            ],
          ],
        ),
      ),
    );
  }
}
