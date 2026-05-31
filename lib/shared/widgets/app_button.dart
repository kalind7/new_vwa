import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_radius.dart';
import '../../config/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.height = 44,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final double height;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsForVariant(variant);
    final borderColor = variant == AppButtonVariant.secondary
        ? AppColors.gray400
        : colors.background;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D101828),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: colors.background,
            foregroundColor: colors.foreground,
            disabledBackgroundColor: AppColors.gray200,
            disabledForegroundColor: AppColors.gray400,
            textStyle: AppTextStyles.textMdMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(color: borderColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  _AppButtonColors _colorsForVariant(AppButtonVariant variant) {
    return switch (variant) {
      AppButtonVariant.primary => const _AppButtonColors(
        background: AppColors.gray400,
        foreground: AppColors.white,
      ),
      AppButtonVariant.secondary => const _AppButtonColors(
        background: AppColors.white,
        foreground: AppColors.gray400,
      ),
      AppButtonVariant.ghost => const _AppButtonColors(
        background: Colors.transparent,
        foreground: AppColors.indigo600,
      ),
    };
  }
}

class _AppButtonColors {
  const _AppButtonColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
