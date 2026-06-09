import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../booking/presentation/providers/wash_bookings_provider.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WashBookingsProvider>().loadBookings();
    });
  }

  String _paymentLabel(String? method) {
    return switch (method?.toLowerCase()) {
      'online' => 'Online payment',
      'cod' => 'Cash on delivery',
      _ => method ?? 'Payment',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'History'),
      body: Consumer<WashBookingsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.bookings.isEmpty) {
            return const AppLoadingOverlay();
          }

          if (provider.bookings.isEmpty) {
            return Center(
              child: Text(
                'No payment history yet.',
                style: AppTextStyles.textMdRegular.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadBookings,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              itemCount: provider.bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final booking = provider.bookings[index];
                return _HistoryItem(
                  station: booking.station,
                  method: _paymentLabel(booking.paymentMethod),
                  time: booking.time,
                  amount: booking.price,
                  status: booking.status,
                );
              },
            ),
          );
        },
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
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    method,
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  Text(
                    time,
                    style: AppTextStyles.textSmRegular.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: AppTextStyles.textMdSemiBold.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  status,
                  style: AppTextStyles.textSmMedium.copyWith(
                    color: AppColors.brand500,
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
