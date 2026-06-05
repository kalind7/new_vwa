import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_config.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../booking/data/datasources/payment_remote_data_source.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../../booking/presentation/providers/wash_bookings_provider.dart';
import '../../data/booking_flow_mock_data.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  var _promoExpanded = false;
  var _isApplyingPromo = false;
  var _isCreatingBooking = false;
  final _promoController = TextEditingController();
  late BookingDraft _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
    final promo = widget.draft.promoCode;
    if (promo != null && promo.isNotEmpty) {
      _promoController.text = promo;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  double _checkoutAmount() {
    final label = checkoutTotalLabel(_draft);
    final digits = label.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(digits) ?? 0;
  }

  void _togglePromo() {
    if (_promoExpanded) {
      FocusScope.of(context).unfocus();
    }
    setState(() => _promoExpanded = !_promoExpanded);
  }

  Future<void> _applyPromo() async {
    FocusScope.of(context).unfocus();
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      AppToast.showError(context, 'Enter a promo code.');
      return;
    }

    if (AppConfig.useMockData) {
      setState(() => _draft = _draft.copyWith(promoCode: code));
      AppToast.showSuccess(context, 'Promo code applied.');
      return;
    }

    setState(() => _isApplyingPromo = true);
    final result = await context
        .read<PaymentRemoteDataSource>()
        .validatePromoCode(code: code, amount: _checkoutAmount());
    if (!mounted) {
      return;
    }
    setState(() => _isApplyingPromo = false);

    result.fold((failure) => AppToast.showError(context, failure.message), (
      message,
    ) {
      setState(() => _draft = _draft.copyWith(promoCode: code));
      AppToast.showSuccess(context, message);
    });
  }

  Future<void> _proceedToPayment() async {
    FocusScope.of(context).unfocus();

    if (AppConfig.useMockData) {
      Navigator.of(context).pushNamed(AppRoutes.paymentMethod, arguments: _draft);
      return;
    }

    setState(() => _isCreatingBooking = true);
    final result = await context.read<BookingRepository>().createBooking(_draft);
    if (!mounted) {
      return;
    }
    setState(() => _isCreatingBooking = false);

    await result.fold(
      (failure) async {
        AppToast.showError(context, failure.message);
      },
      (booking) async {
        context.read<WashBookingsProvider>().loadBookings();
        final draftWithId = _draft.copyWith(bookingId: booking.id);
        setState(() => _draft = draftWithId);
        AppToast.showSuccess(context, 'Booking created successfully.');
        await Navigator.of(context).pushNamed(
          AppRoutes.paymentMethod,
          arguments: draftWithId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = checkoutTotalLabel(_draft);
    final duration = checkoutDurationLabel(_draft.service.duration);
    final vehicleNumber = _draft.vehicle?.plate ?? '—';

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: buildAppScreenHeader(context, title: 'Checkout'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _WashSummaryCard(
                      stationName: _draft.station.name,
                      vehicleNumber: vehicleNumber,
                      duration: duration,
                      total: total,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _PromoCodeCard(
                      expanded: _promoExpanded,
                      controller: _promoController,
                      onToggle: _togglePromo,
                      onApply: _applyPromo,
                    ),
                  ],
                ),
              ),
              if (_isApplyingPromo || _isCreatingBooking) const AppLoadingOverlay(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ColoredBox(
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 1, color: AppColors.gray200),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Proceed to payment',
                  onPressed: _proceedToPayment,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WashSummaryCard extends StatelessWidget {
  const _WashSummaryCard({
    required this.stationName,
    required this.vehicleNumber,
    required this.duration,
    required this.total,
  });

  final String stationName;
  final String vehicleNumber;
  final String duration;
  final String total;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
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
            Text(
              'Wash summary',
              style: AppTextStyles.textXlSemiBold.copyWith(
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SummaryRow(label: 'Station', value: stationName),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(label: 'Vehicle number', value: vehicleNumber),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(label: 'Duration', value: duration),
            const Divider(height: AppSpacing.xxxl, color: AppColors.gray200),
            Row(
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.textMdSemiBold.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
                const Spacer(),
                Text(
                  total,
                  style: AppTextStyles.textMdSemiBold.copyWith(
                    color: AppColors.gray900,
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

class _PromoCodeCard extends StatelessWidget {
  const _PromoCodeCard({
    required this.expanded,
    required this.controller,
    required this.onToggle,
    required this.onApply,
  });

  final bool expanded;
  final TextEditingController controller;
  final VoidCallback onToggle;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: AppSvgIcon(
                        AppSvgIconName.gift,
                        color: AppColors.gray500,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Promotional Code',
                      style: AppTextStyles.textMdSemiBold.copyWith(
                        color: AppColors.gray900,
                      ),
                    ),
                  ),
                  Icon(
                    expanded ? Icons.keyboard_arrow_up : Icons.chevron_right,
                    color: AppColors.gray500,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: controller,
                hintText: 'Enter Promo code',
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => onApply(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: 'Apply', height: 44, onPressed: onApply),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.textMdRegular.copyWith(color: AppColors.gray600),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.textMdSemiBold.copyWith(
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }
}
