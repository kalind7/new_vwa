import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_spacing.dart';
import '../../config/app_text_styles.dart';

/// Gray/100 tab header used on Wash history and similar Dev Handoff screens.
class DevHandoffTabHeader extends StatelessWidget {
  const DevHandoffTabHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.gray100,
        border: Border(bottom: BorderSide(color: AppColors.gray200)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D101828),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textLgSemiBold.copyWith(
                    color: AppColors.gray800,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
