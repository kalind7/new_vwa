import 'package:flutter/material.dart';

import '../../config/app_breakpoints.dart';
import '../../config/app_colors.dart';
import '../../config/app_radius.dart';
import '../../config/app_spacing.dart';
import '../../config/app_text_styles.dart';
import 'app_button.dart';
import 'app_svg_icon.dart';

Future<T?> showAppActionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required String message,
  required String primaryLabel,
  required VoidCallback onPrimaryPressed,
  AppSvgIconName? icon,
  Widget? content,
  String? secondaryLabel,
  VoidCallback? onSecondaryPressed,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AppActionBottomSheet(
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        onPrimaryPressed: onPrimaryPressed,
        icon: icon,
        content: content,
        secondaryLabel: secondaryLabel,
        onSecondaryPressed: onSecondaryPressed,
      );
    },
  );
}

class AppActionBottomSheet extends StatelessWidget {
  const AppActionBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.icon,
    this.content,
    this.secondaryLabel,
    this.onSecondaryPressed,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final AppSvgIconName? icon;
  final Widget? content;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppBreakpoints.horizontalPadding(width),
              0,
              AppBreakpoints.horizontalPadding(width),
              AppSpacing.lg + bottomInset,
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl),
                  bottom: Radius.circular(AppRadius.xl),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gray300,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      if (icon != null) ...[
                        Center(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.brand500.withValues(alpha: .1),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: AppSvgIcon(
                                icon!,
                                color: AppColors.brand500,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textXlSemiBold.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textSmRegular.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      if (content != null) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        content!,
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                      AppButton(
                        label: primaryLabel,
                        onPressed: onPrimaryPressed,
                      ),
                      if (secondaryLabel != null &&
                          onSecondaryPressed != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        AppButton(
                          label: secondaryLabel!,
                          variant: AppButtonVariant.secondary,
                          onPressed: onSecondaryPressed,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
