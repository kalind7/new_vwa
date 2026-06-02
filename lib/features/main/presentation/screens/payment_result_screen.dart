import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_success_icon.dart';
import '../../data/booking_flow_mock_data.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    if (!draft.isSuccess) {
      return _PaymentFailedView(draft: draft);
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppSuccessIcon(),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(
                      'Payment Confirmed!',
                      style: AppTextStyles.textXlSemiBold.copyWith(
                        color: AppColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.gray200),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                      label: 'Go to home',
                      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.mainShell,
                        (route) => false,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Leave a review',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.leaveReview,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentFailedView extends StatelessWidget {
  const _PaymentFailedView({required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Payment Failed',
                  style: AppTextStyles.textXlSemiBold.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Your payment could not be completed.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textMdRegular.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                AppButton(
                  label: 'Try again',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
