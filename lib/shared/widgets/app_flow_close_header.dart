import 'package:flutter/material.dart';

import '../../config/app_breakpoints.dart';
import '../../config/app_colors.dart';
import '../../config/app_spacing.dart';
import '../../shared/widgets/app_svg_icon.dart';

class AppFlowCloseHeader extends StatelessWidget {
  const AppFlowCloseHeader({super.key, this.onClose});

  final VoidCallback? onClose;

  static const double topOffset = AppSpacing.xxl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppBreakpoints.maxMobileContentWidth,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            MediaQuery.paddingOf(context).top + topOffset,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Material(
            color: AppColors.gray800,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onClose ?? () => Navigator.of(context).maybePop(),
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: AppSvgIcon(
                    AppSvgIconName.close,
                    color: AppColors.white,
                    size: 20,
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
