import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../shared/widgets/app_svg_icon.dart';

class AppSuccessIcon extends StatelessWidget {
  const AppSuccessIcon({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 48,
      height: size + 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.green100.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: size + 48, height: size + 48),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.green700,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: size,
              height: size,
              child: const Center(
                child: AppSvgIcon(
                  AppSvgIconName.success,
                  color: AppColors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
