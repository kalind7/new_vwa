import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../data/booking_flow_mock_data.dart';
import '../widgets/booking_flow_scaffold.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  var _promoExpanded = true;

  @override
  Widget build(BuildContext context) {
    final total = widget.draft.service.price.replaceFirst('Nrs ', 'Rs ');

    return BookingFlowScaffold(
      title: 'Checkout',
      backgroundColor: AppColors.gray50,
      bottomBar: AppButton(
        label: 'Proceed to payment',
        onPressed: () => Navigator.of(context).pushNamed(
          AppRoutes.paymentMethod,
          arguments: widget.draft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WashSummaryCard(
            stationName: widget.draft.station.name,
            duration: widget.draft.service.duration,
            total: total,
          ),
          const SizedBox(height: AppSpacing.lg),
          _PromoCodeCard(
            expanded: _promoExpanded,
            onToggle: () => setState(() => _promoExpanded = !_promoExpanded),
          ),
        ],
      ),
    );
  }
}

class _WashSummaryCard extends StatelessWidget {
  const _WashSummaryCard({
    required this.stationName,
    required this.duration,
    required this.total,
  });

  final String stationName;
  final String duration;
  final String total;

  @override
  Widget build(BuildContext context) {
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
            _SummaryRow(label: 'Duration', value: duration),
            const Divider(height: AppSpacing.xxxl),
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
    required this.onToggle,
  });

  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.md),
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
                        AppSvgIconName.payment,
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
                    expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.gray500,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: AppSpacing.lg),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Promo code',
                  hintStyle: AppTextStyles.textMdRegular.copyWith(
                    color: AppColors.gray500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Apply',
                height: 40,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Promo code applied (mock).')),
                  );
                },
              ),
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
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.textMdRegular.copyWith(
              color: AppColors.gray600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.textMdSemiBold.copyWith(
              color: AppColors.gray900,
            ),
          ),
        ),
      ],
    );
  }
}
