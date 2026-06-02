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
    this.onCheckOut,
  });

  final WashBookingMock booking;
  final VoidCallback onCancel;
  final VoidCallback? onCheckOut;

  bool get _isBooked => booking.canCancel && booking.status != 'Completed';

  @override
  Widget build(BuildContext context) {
    final isComplete = booking.status == 'Completed';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.gray200),
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
            InkWell(
              onTap: _isBooked ? onCheckOut : null,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Station: ${booking.station}',
                            style: AppTextStyles.textMdMedium.copyWith(
                              color: AppColors.gray900,
                            ),
                          ),
                        ),
                        _StatusBadge(status: booking.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Location: ${booking.location}',
                      style: AppTextStyles.textSmRegular.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Vehicle number: ${booking.vehicle}',
                      style: AppTextStyles.textSmRegular.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isBooked) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Check out',
                onPressed: onCheckOut,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Cancel booking',
                variant: AppButtonVariant.secondary,
                onPressed: onCancel,
              ),
            ] else if (isComplete) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Bike wash has been completed',
                style: AppTextStyles.textSmMedium.copyWith(
                  color: AppColors.success600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'Completed';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.success100 : AppColors.orange50,
        border: Border.all(
          color: isCompleted ? AppColors.success200 : AppColors.orange100,
        ),
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
            color: isCompleted ? AppColors.success600 : AppColors.orange600,
          ),
        ),
      ),
    );
  }
}
