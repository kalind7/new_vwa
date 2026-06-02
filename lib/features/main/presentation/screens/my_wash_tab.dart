import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/shimmers/station_card_shimmer.dart';
import '../../../../shared/widgets/dev_handoff_tab_header.dart';
import '../../../booking/presentation/providers/wash_bookings_provider.dart';
import '../../data/main_shell_mock_data.dart';
import '../widgets/wash_booking_card.dart';

class MyWashTab extends StatelessWidget {
  const MyWashTab({super.key});

  static Map<String, List<WashBookingMock>> _groupedBookings(
    List<WashBookingMock> bookings,
  ) {
    final grouped = <String, List<WashBookingMock>>{};
    for (final booking in bookings) {
      grouped.putIfAbsent(booking.date, () => []).add(booking);
    }
    return grouped;
  }

  void _openWashDetail(BuildContext context, WashBookingMock booking) {
    Navigator.of(context).pushNamed(AppRoutes.washDetail, arguments: booking);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DevHandoffTabHeader(title: 'Wash history'),
          Expanded(
            child: Consumer<WashBookingsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.bookings.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xxl,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: StationListShimmer(itemCount: 3),
                  );
                }

                final grouped = _groupedBookings(provider.bookings);

                if (grouped.isEmpty) {
                  return const _EmptyWashHistory();
                }

                return RefreshIndicator(
                  onRefresh: provider.loadBookings,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xxl,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    children: [
                      for (final entry in grouped.entries) ...[
                        Text(
                          entry.key,
                          style: AppTextStyles.textSmMedium.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        for (final booking in entry.value) ...[
                          WashBookingCard(
                            booking: booking,
                            onViewDetails: () =>
                                _openWashDetail(context, booking),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWashHistory extends StatelessWidget {
  const _EmptyWashHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Text(
          'No wash bookings yet.\nBook a slot from a station to see your history here.',
          textAlign: TextAlign.center,
          style: AppTextStyles.textMdRegular.copyWith(color: AppColors.gray500),
        ),
      ),
    );
  }
}
