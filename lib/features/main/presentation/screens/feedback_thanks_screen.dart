import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class FeedbackThanksScreen extends StatelessWidget {
  const FeedbackThanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Text('❤️', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Thanks for your feedback!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textXlSemiBold.copyWith(
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxxl,
                      ),
                      child: Text(
                        'We thank you for taking your time and giving us your feed back',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textMdRegular.copyWith(
                          color: AppColors.gray500,
                        ),
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
                child: AppButton(
                  label: 'Done',
                  onPressed: () =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.mainShell,
                        (route) => false,
                        arguments: 1,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
