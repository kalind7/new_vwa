import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../data/main_shell_mock_data.dart';
import '../widgets/wash_booking_card.dart';

class MyWashTab extends StatelessWidget {
  const MyWashTab({super.key});

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
              AppSpacing.lg,
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
                  const _WashSummaryStrip(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            sliver: SliverList.separated(
              itemCount: washBookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                return WashBookingCard(
                  booking: washBookings[index],
                  onCancel: () => _showCancelMock(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelMock(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock cancel booking action selected.')),
    );
  }
}

class _WashSummaryStrip extends StatelessWidget {
  const _WashSummaryStrip();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _WashSummaryCard(
            label: 'Booked',
            value: '1',
            icon: Icons.event_available_outlined,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _WashSummaryCard(
            label: 'Completed',
            value: '1',
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class _WashSummaryCard extends StatelessWidget {
  const _WashSummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gray900,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(height: AppSpacing.lg),
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
            ),
            Text(
              label,
              style: AppTextStyles.textSmRegular.copyWith(
                color: AppColors.gray300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
