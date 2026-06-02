import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_screen_header.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'History'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          Text(
            'Today',
            style: AppTextStyles.textMdSemiBold.copyWith(
              color: AppColors.gray800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _HistoryItem(
            station: 'Clean Wave Station',
            method: 'Via Esewa',
            time: '08:00 AM',
            amount: 'NPR 200',
            status: 'Completed',
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.station,
    required this.method,
    required this.time,
    required this.amount,
    required this.status,
  });

  final String station;
  final String method;
  final String time;
  final String amount;
  final String status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray50,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station,
                    style: AppTextStyles.textMdSemiBold.copyWith(
                      color: AppColors.gray800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    method,
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text(
                        'Wash',
                        style: AppTextStyles.textXsMedium.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 1,
                        height: 12,
                        color: AppColors.gray300,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        time,
                        style: AppTextStyles.textXsMedium.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.success100,
                    borderRadius: BorderRadius.circular(6.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      status,
                      style: AppTextStyles.textXsMedium.copyWith(
                        color: AppColors.success700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  amount,
                  style: AppTextStyles.textMdSemiBold.copyWith(
                    color: AppColors.black,
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
