import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/shimmers/station_card_shimmer.dart';
import '../../../booking/presentation/providers/wash_bookings_provider.dart';
import '../../data/main_shell_mock_data.dart';
import '../widgets/wash_booking_card.dart';

enum _WashHistoryTab { active, completed, cancelled }

class WashHistoryScreen extends StatefulWidget {
  const WashHistoryScreen({super.key});

  @override
  State<WashHistoryScreen> createState() => _WashHistoryScreenState();
}

class _WashHistoryScreenState extends State<WashHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WashBookingsProvider>().loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<WashBookingMock> _filter(
    List<WashBookingMock> bookings,
    _WashHistoryTab tab,
  ) {
    return bookings.where((booking) {
      final status = booking.status.toLowerCase();
      return switch (tab) {
        _WashHistoryTab.active => booking.isActiveBooking,
        _WashHistoryTab.completed => status.contains('completed'),
        _WashHistoryTab.cancelled => status.contains('cancelled'),
      };
    }).toList();
  }

  void _openDetail(WashBookingMock booking) {
    Navigator.of(context).pushNamed(AppRoutes.washDetail, arguments: booking);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Wash history'),
      body: Column(
        children: [
          Material(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.brand500,
              unselectedLabelColor: AppColors.gray500,
              indicatorColor: AppColors.brand500,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          Expanded(
            child: Consumer<WashBookingsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.bookings.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: StationListShimmer(itemCount: 4),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _WashHistoryList(
                      bookings: _filter(provider.bookings, _WashHistoryTab.active),
                      emptyMessage:
                          'No active washes.\nBook a slot from Home to get started.',
                      onRefresh: provider.loadBookings,
                      onTap: _openDetail,
                    ),
                    _WashHistoryList(
                      bookings:
                          _filter(provider.bookings, _WashHistoryTab.completed),
                      emptyMessage: 'No completed washes yet.',
                      onRefresh: provider.loadBookings,
                      onTap: _openDetail,
                    ),
                    _WashHistoryList(
                      bookings:
                          _filter(provider.bookings, _WashHistoryTab.cancelled),
                      emptyMessage: 'No cancelled bookings.',
                      onRefresh: provider.loadBookings,
                      onTap: _openDetail,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WashHistoryList extends StatelessWidget {
  const _WashHistoryList({
    required this.bookings,
    required this.emptyMessage,
    required this.onRefresh,
    required this.onTap,
  });

  final List<WashBookingMock> bookings;
  final String emptyMessage;
  final Future<void> Function() onRefresh;
  final void Function(WashBookingMock booking) onTap;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<WashBookingMock>>{};
    for (final booking in bookings) {
      grouped.putIfAbsent(booking.date, () => []).add(booking);
    }

    if (grouped.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.textMdRegular.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
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
                onTap: () => onTap(booking),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ],
      ),
    );
  }
}
