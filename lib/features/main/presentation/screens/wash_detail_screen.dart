import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flow_modal.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../data/booking_flow_mock_data.dart';
import '../../data/main_shell_mock_data.dart';

class WashDetailScreen extends StatefulWidget {
  const WashDetailScreen({super.key, required this.booking});

  final WashBookingMock booking;

  @override
  State<WashDetailScreen> createState() => _WashDetailScreenState();
}

class _WashDetailScreenState extends State<WashDetailScreen> {
  var _isCancelled = false;

  WashBookingMock get booking => widget.booking;

  Future<void> _confirmCancel() async {
    final shouldCancel = await showAppFlowModal(
      context: context,
      messageLines: const ['Are you sure you want ', 'cancel booking?'],
    );

    if (shouldCancel && mounted) {
      setState(() => _isCancelled = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'My Wash'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: _isCancelled
              ? _CancelledContent(
                  onGoBack: () => Navigator.of(context).maybePop(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: _BookingDetailContent(
                    booking: booking,
                    onCheckOut: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.bookingSummary,
                        arguments: bookingDraftFromWashBooking(booking),
                      );
                    },
                    onCancel: _confirmCancel,
                  ),
                ),
        ),
      ),
    );
  }
}

class _BookingDetailContent extends StatelessWidget {
  const _BookingDetailContent({
    required this.booking,
    required this.onCheckOut,
    required this.onCancel,
  });

  final WashBookingMock booking;
  final VoidCallback onCheckOut;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isCompleted = booking.status == 'Completed';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          booking.date,
          style: AppTextStyles.textMdSemiBold.copyWith(
            color: AppColors.gray800,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        DecoratedBox(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking.station,
                        style: AppTextStyles.textMdMedium.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                    ),
                    _StatusBadge(status: booking.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '${booking.date}, ${booking.time}',
                  style: AppTextStyles.textMdMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  booking.price,
                  style: AppTextStyles.textMdMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                if (!isCompleted) ...[
                  const SizedBox(height: AppSpacing.sm),
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
                if (booking.canCancel) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Check out',
                          onPressed: onCheckOut,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppButton(
                          label: 'Cancel booking',
                          variant: AppButtonVariant.secondary,
                          onPressed: onCancel,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
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
        ),
      ],
    );
  }
}

class _CancelledContent extends StatelessWidget {
  const _CancelledContent({required this.onGoBack});

  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxxl),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.green100,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.green700,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: AppSvgIcon(
                    AppSvgIconName.wash,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            'Booking cancelled',
            style: AppTextStyles.textMdRegular.copyWith(
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          AppButton(label: 'Go back to my wash', onPressed: onGoBack),
        ],
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
    final isInWash = status == 'In wash';

    final backgroundColor = isCompleted
        ? AppColors.success100
        : isInWash
        ? AppColors.blue50
        : AppColors.orange50;
    final borderColor = isCompleted
        ? AppColors.success200
        : isInWash
        ? AppColors.blue600
        : AppColors.orange100;
    final textColor = isCompleted
        ? AppColors.success600
        : isInWash
        ? AppColors.blue700
        : AppColors.orange600;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          status,
          style: AppTextStyles.textXsMedium.copyWith(color: textColor),
        ),
      ),
    );
  }
}
