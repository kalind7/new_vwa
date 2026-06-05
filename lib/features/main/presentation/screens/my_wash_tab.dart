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

enum _WashHistoryFilter { active, completed }

class MyWashTab extends StatefulWidget {
  const MyWashTab({super.key});

  @override
  State<MyWashTab> createState() => _MyWashTabState();
}

class _MyWashTabState extends State<MyWashTab> {
  _WashHistoryFilter _filter = _WashHistoryFilter.active;

  static Map<String, List<WashBookingMock>> _groupedBookings(
    List<WashBookingMock> bookings,
  ) {
    final grouped = <String, List<WashBookingMock>>{};
    for (final booking in bookings) {
      grouped.putIfAbsent(booking.date, () => []).add(booking);
    }
    return grouped;
  }

  List<WashBookingMock> _filtered(List<WashBookingMock> bookings) {
    return bookings.where((booking) {
      final status = booking.status.toLowerCase();
      final isCompleted =
          status.contains('completed') || status.contains('cancelled');
      return _filter == _WashHistoryFilter.completed
          ? isCompleted
          : !isCompleted;
    }).toList();
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: SegmentedButton<_WashHistoryFilter>(
              segments: const [
                ButtonSegment(
                  value: _WashHistoryFilter.active,
                  label: Text('Booked'),
                ),
                ButtonSegment(
                  value: _WashHistoryFilter.completed,
                  label: Text('Completed'),
                ),
              ],
              selected: {_filter},
              onSelectionChanged: (value) {
                setState(() => _filter = value.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.brand500;
                  }
                  return AppColors.gray100;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.white;
                  }
                  return AppColors.gray700;
                }),
              ),
            ),
          ),
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

                final filtered = _filtered(provider.bookings);
                final grouped = _groupedBookings(filtered);

                if (grouped.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: provider.loadBookings,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _EmptyWashHistory(
                          isCompleted:
                              _filter == _WashHistoryFilter.completed,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: provider.loadBookings,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
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
  const _EmptyWashHistory({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle_outline : Icons.local_car_wash,
              size: 48,
              color: AppColors.gray400,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isCompleted
                  ? 'No completed washes yet.'
                  : 'No active bookings.\nBook a slot from Home to get started.',
              textAlign: TextAlign.center,
              style: AppTextStyles.textMdRegular.copyWith(
                color: AppColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
