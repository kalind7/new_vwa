import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo_mark.dart';
import '../../../../shared/widgets/app_screen.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/auth_tab_switcher.dart';

class FoundationPreviewScreen extends StatefulWidget {
  const FoundationPreviewScreen({super.key});

  @override
  State<FoundationPreviewScreen> createState() =>
      _FoundationPreviewScreenState();
}

class _FoundationPreviewScreenState extends State<FoundationPreviewScreen> {
  int _selectedAuthTab = 0;

  void _showPreviewMessage(String label) {
    AppToast.showNeutral(context, '$label preview button is connected.');
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      backgroundColor: AppColors.gray900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          const AppLogoMark(),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            'Milestone 1',
            style: AppTextStyles.headingH1.copyWith(color: AppColors.lightText),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Figma colors, typography, base components, and route shell are ready.',
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.gray300,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthTabSwitcher(
                      selectedIndex: _selectedAuthTab,
                      onChanged: (index) {
                        setState(() => _selectedAuthTab = index);
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const AppTextField(
                      label: 'Email',
                      initialValue: 'Loisbecket@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const AppTextField(
                      label: 'Password',
                      initialValue: '*******',
                      obscureText: true,
                      suffixIcon: Icon(Icons.visibility_off_outlined, size: 18),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      label: 'Login',
                      onPressed: () => _showPreviewMessage('Login'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Sign Up',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => _showPreviewMessage('Sign Up'),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text('Color Tokens', style: AppTextStyles.textMdSemiBold),
                    const SizedBox(height: AppSpacing.md),
                    const _ColorTokenRow(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorTokenRow extends StatelessWidget {
  const _ColorTokenRow();

  @override
  Widget build(BuildContext context) {
    const colors = [
      AppColors.gray900,
      AppColors.indigo600,
      AppColors.secondary500,
      AppColors.secondary400,
      AppColors.error500,
      AppColors.gray400,
    ];

    return Row(
      children: [
        for (final color in colors) ...[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gray200),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}
