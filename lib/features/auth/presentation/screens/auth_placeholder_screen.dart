import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_screen.dart';

class AuthPlaceholderScreen extends StatelessWidget {
  const AuthPlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.gray900,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const Spacer(),
          Text(title, style: AppTextStyles.headingH1),
          const SizedBox(height: AppSpacing.md),
          Text(
            'This route is connected for Milestone 2. The static auth UI will be built in Milestone 3.',
            style: AppTextStyles.textSmRegular,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: 'Back to onboarding',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
