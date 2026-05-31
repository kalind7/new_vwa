import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_logo_mark.dart';
import '../../../../shared/widgets/app_screen.dart';

class AuthFlowLayout extends StatelessWidget {
  const AuthFlowLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.bottom,
    this.showBackButton = false,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      backgroundColor: AppColors.gray900,
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 700;
          final headerHeight = isCompact ? 188.0 : 236.0;

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.xxl,
                        isCompact ? AppSpacing.md : AppSpacing.xxl,
                        AppSpacing.xxl,
                        AppSpacing.xxl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showBackButton)
                            _HeaderBackButton(onPressed: onBack)
                          else
                            const AppLogoMark(),
                          const Spacer(),
                          Text(
                            title,
                            style: AppTextStyles.headingH1.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              subtitle!,
                              style: AppTextStyles.textSmRegular.copyWith(
                                color: AppColors.gray300,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.xl),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xxl,
                        AppSpacing.xxl,
                        AppSpacing.xxl,
                        AppSpacing.xxxl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          child,
                          if (bottom != null) ...[
                            const SizedBox(height: AppSpacing.xxl),
                            bottom!,
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.white.withValues(alpha: 0.08),
        foregroundColor: AppColors.white,
      ),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}
