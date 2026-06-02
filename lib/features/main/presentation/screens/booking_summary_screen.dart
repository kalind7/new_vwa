import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/booking_flow_mock_data.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  var _promoExpanded = true;
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = checkoutTotalLabel(widget.draft);
    final duration = checkoutDurationLabel(widget.draft.service.duration);

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Checkout',
          style: AppTextStyles.textLgSemiBold.copyWith(
            color: AppColors.gray800,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Center(
            child: Material(
              color: AppColors.gray800,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: AppSvgIcon(
                      AppSvgIconName.arrowLeft,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _WashSummaryCard(
            stationName: widget.draft.station.name,
            duration: duration,
            total: total,
          ),
          const SizedBox(height: AppSpacing.lg),
          _PromoCodeCard(
            expanded: _promoExpanded,
            controller: _promoController,
            onToggle: () => setState(() => _promoExpanded = !_promoExpanded),
          ),
        ],
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
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.paymentMethod,
                    arguments: widget.draft,
                  ),
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
  });

  final bool expanded;
  final TextEditingController controller;
  final VoidCallback onToggle;

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
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
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
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Apply',
                height: 44,
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
        Text(
          label,
          style: AppTextStyles.textMdRegular.copyWith(
            color: AppColors.gray600,
          ),
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
