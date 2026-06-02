import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_config.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_loading_overlay.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../booking/data/datasources/payment_remote_data_source.dart';
import '../../data/booking_flow_mock_data.dart';
import '../providers/booking_flow_provider.dart';
import '../widgets/booking_flow_scaffold.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  var _isProcessing = false;

  Future<void> _handlePaymentTap(
    BuildContext context,
    BookingFlowProvider provider,
    PaymentMethodMock method,
  ) async {
    provider.selectPaymentMethod(method);
    final updatedDraft = provider.draft.copyWith(
      paymentMethod: method,
      isSuccess: true,
    );

    if (AppConfig.useMockData) {
      if (!context.mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pushNamed(AppRoutes.paymentResult, arguments: updatedDraft);
      return;
    }

    final bookingId = updatedDraft.bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      AppToast.showError(
        context,
        'Booking reference missing. Complete booking first.',
      );
      return;
    }

    setState(() => _isProcessing = true);
    final result = await context
        .read<PaymentRemoteDataSource>()
        .initiatePayment(bookingId: bookingId, paymentMethod: method.id);
    if (!mounted) {
      return;
    }
    setState(() => _isProcessing = false);

    result.fold((failure) => AppToast.showError(context, failure.message), (_) {
      Navigator.of(
        context,
      ).pushNamed(AppRoutes.paymentResult, arguments: updatedDraft);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingFlowProvider(
        station: widget.draft.station,
        vehicle: widget.draft.vehicle,
        initialService: widget.draft.service,
        initialSlot: widget.draft.slot,
        initialPaymentMethod: widget.draft.paymentMethod,
      ),
      child: Consumer<BookingFlowProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              BookingFlowScaffold(
                title: 'Billing Method',
                backgroundColor: AppColors.gray50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PriceSummaryCard(draft: provider.draft),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Choose billing methods',
                      style: AppTextStyles.textSmMedium.copyWith(
                        color: AppColors.gray700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final method in paymentMethods) ...[
                      _PaymentOption(
                        method: method,
                        onTap: _isProcessing
                            ? null
                            : () =>
                                  _handlePaymentTap(context, provider, method),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
              if (_isProcessing) const AppLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}

class _PriceSummaryCard extends StatelessWidget {
  const _PriceSummaryCard({required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final price = checkoutTotalLabel(draft).replaceFirst('Rs ', '');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
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
          children: [
            _BillingRow(label: 'Price', value: price),
            const SizedBox(height: AppSpacing.md),
            _BillingRow(label: 'Promotional discount', value: '-'),
            const Divider(height: AppSpacing.xxl),
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
                  checkoutTotalLabel(draft),
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

class _BillingRow extends StatelessWidget {
  const _BillingRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.textMdRegular.copyWith(
              color: AppColors.gray600,
            ),
          ),
        ),
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

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({required this.method, this.onTap});

  final PaymentMethodMock method;
  final VoidCallback? onTap;

  String get _label => switch (method.id) {
    'khalti' => 'Khalti by IME',
    'esewa' => 'eSewa Mobile Wallet',
    'cash' => 'Cash on Delivery',
    _ => method.title,
  };

  Color get _iconColor => switch (method.id) {
    'khalti' => const Color(0xFF5C2D91),
    'esewa' => AppColors.green600,
    'cash' => AppColors.blue600,
    _ => AppColors.gray700,
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.gray300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: AppSvgIcon(
                    method.id == 'cash'
                        ? AppSvgIconName.wallet
                        : AppSvgIconName.card,
                    color: _iconColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  _label,
                  style: AppTextStyles.textSmMedium.copyWith(
                    color: AppColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const AppSvgIcon(
                AppSvgIconName.chevronRight,
                color: AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
