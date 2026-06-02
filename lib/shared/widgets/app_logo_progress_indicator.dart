import 'package:flutter/material.dart';

import '../../config/app_assets.dart';
import '../../config/app_colors.dart';

class AppLogoProgressIndicator extends StatelessWidget {
  const AppLogoProgressIndicator({
    super.key,
    this.size = 48,
    this.progressColor,
  });

  final double size;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: size * 0.05,
              color: progressColor ?? AppColors.gray400,
            ),
          ),
          Image.asset(
            AppAssets.splashLogo,
            width: size * 0.42,
            height: size * 0.42,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
