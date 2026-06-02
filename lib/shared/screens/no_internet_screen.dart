import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_breakpoints.dart';
import '../../config/app_colors.dart';
import '../../config/app_spacing.dart';
import '../../config/app_text_styles.dart';
import '../../core/connectivity/connectivity_provider.dart';
import '../widgets/app_button.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppBreakpoints.maxMobileContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 72,
                    color: AppColors.gray400,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Text(
                    'No internet connection',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textXlSemiBold.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Turn on mobile data or Wi‑Fi to use Vehicle Washing App.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textMdRegular.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  AppButton(
                    label: 'Try again',
                    onPressed: () =>
                        context.read<ConnectivityProvider>().recheck(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
