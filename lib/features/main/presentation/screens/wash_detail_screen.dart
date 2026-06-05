import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flow_modal.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../../booking/presentation/providers/wash_bookings_provider.dart';
import '../../data/booking_flow_mock_data.dart';
import '../../data/main_shell_mock_data.dart';
import '../widgets/wash_booking_progress_card.dart';
import '../widgets/wash_booking_summary_card.dart';

class WashDetailScreen extends StatefulWidget {
  const WashDetailScreen({super.key, required this.booking});

  final WashBookingMock booking;

  @override
  State<WashDetailScreen> createState() => _WashDetailScreenState();
}

class _WashDetailScreenState extends State<WashDetailScreen> {
  late WashBookingMock _booking;
  var _isCancelled = false;
  var _isLoading = false;
  var _isCancelling = false;
  Timer? _statusPollTimer;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
    _loadBookingDetail();
    _statusPollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _loadBookingDetail(),
    );
  }

  @override
  void dispose() {
    _statusPollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadBookingDetail() async {
    final bookingId = _booking.id;
    if (bookingId == null || bookingId.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);
    final result = await context.read<BookingRepository>().fetchBookingDetail(
      bookingId,
    );
    if (!mounted) {
      return;
    }

    result.fold((_) {}, (detail) => _booking = detail);
    setState(() => _isLoading = false);
  }

  Future<void> _confirmCancel() async {
    final shouldCancel = await showAppFlowModal(
      context: context,
      message: 'Are you sure you want to cancel your booking?',
    );

    if (!shouldCancel || !mounted) {
      return;
    }

    final bookingId = _booking.id;
    if (bookingId == null || bookingId.isEmpty) {
      setState(() => _isCancelled = true);
      return;
    }

    setState(() => _isCancelling = true);
    final result = await context.read<BookingRepository>().cancelBooking(
      bookingId,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isCancelling = false);

    await result.fold(
      (failure) async {
        AppToast.showError(context, failure.message);
      },
      (_) async {
        AppToast.showSuccess(context, 'Booking cancelled.');
        context.read<WashBookingsProvider>().loadBookings();
        setState(() => _isCancelled = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Wash detail'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Stack(
            children: [
              _isCancelled
                  ? _CancelledContent(
                      onGoBack: () => Navigator.of(context).maybePop(),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.xxl,
                              AppSpacing.lg,
                              AppSpacing.lg,
                            ),
                            child: _WashDetailBody(
                              booking: _booking,
                              showProgress: !_isCompleted,
                            ),
                          ),
                        ),
                        if (_isActive || _isCompleted)
                          _WashDetailActions(
                            isActive: _isActive,
                            isCompleted: _isCompleted,
                            onCheckOut: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.bookingSummary,
                                arguments: bookingDraftFromWashBooking(
                                  _booking,
                                ),
                              );
                            },
                            onCancel: _confirmCancel,
                            onWriteReview: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.leaveReview,
                                arguments: _booking.id,
                              );
                            },
                          ),
                      ],
                    ),
              if (_isLoading || _isCancelling) const AppLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isCompleted => _booking.status == 'Completed';
  bool get _isActive => _booking.canCancel && !_isCompleted;
}

class _WashDetailBody extends StatelessWidget {
  const _WashDetailBody({required this.booking, required this.showProgress});

  final WashBookingMock booking;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WashBookingSummaryCard(
          stationName: booking.station,
          location: booking.location,
          date: booking.date,
          vehicleNumber: booking.vehicle,
          paidVia: showProgress ? 'eSewa' : null,
          total: booking.price,
          status: showProgress ? null : booking.status,
        ),
        if (showProgress) ...[
          const SizedBox(height: 14),
          WashBookingProgressCard(activeStep: booking.washProgressStep),
        ],
      ],
    );
  }
}

class _WashDetailActions extends StatelessWidget {
  const _WashDetailActions({
    required this.isActive,
    required this.isCompleted,
    required this.onCheckOut,
    required this.onCancel,
    required this.onWriteReview,
  });

  final bool isActive;
  final bool isCompleted;
  final VoidCallback onCheckOut;
  final VoidCallback onCancel;
  final VoidCallback onWriteReview;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isActive) ...[
                AppButton(
                  label: 'Check out',
                  variant: AppButtonVariant.secondary,
                  onPressed: onCheckOut,
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(label: 'Cancel booking', onPressed: onCancel),
              ] else if (isCompleted)
                AppButton(
                  label: 'Write a review',
                  variant: AppButtonVariant.secondary,
                  onPressed: onWriteReview,
                ),
            ],
          ),
        ),
      ),
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
            decoration: const BoxDecoration(
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
