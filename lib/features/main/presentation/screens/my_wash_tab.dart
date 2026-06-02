import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_flow_modal.dart';
import '../../data/booking_flow_mock_data.dart';
import '../../data/main_shell_mock_data.dart';
import '../widgets/wash_booking_card.dart';

class MyWashTab extends StatelessWidget {
  const MyWashTab({super.key});

  static Map<String, List<WashBookingMock>> get _groupedBookings {
    final grouped = <String, List<WashBookingMock>>{};
    for (final booking in washBookings) {
      grouped.putIfAbsent(booking.date, () => []).add(booking);
    }
    return grouped;
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WashBookingMock booking,
  ) async {
    final shouldCancel = await showAppFlowModal(
      context: context,
      messageLines: const ['Are you sure you want ', 'cancel booking?'],
    );

    if (shouldCancel && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled.')),
      );
    }
  }

  void _openCheckout(BuildContext context, WashBookingMock booking) {
    Navigator.of(context).pushNamed(
      AppRoutes.bookingSummary,
      arguments: bookingDraftFromWashBooking(booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xxl,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Wash',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Track your booked and completed bike washes.',
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  for (final entry in _groupedBookings.entries) ...[
                    Text(
                      entry.key,
                      style: AppTextStyles.textMdSemiBold.copyWith(
                        color: AppColors.gray800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final booking in entry.value) ...[
                      WashBookingCard(
                        booking: booking,
                        onCancel: () => _confirmCancel(context, booking),
                        onCheckOut: booking.canCancel
                            ? () => _openCheckout(context, booking)
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
