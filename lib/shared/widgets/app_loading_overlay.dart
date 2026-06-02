import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import 'app_logo_progress_indicator.dart';

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: ColoredBox(
        color: AppColors.white.withValues(alpha: 0.72),
        child: Center(child: AppLogoProgressIndicator(size: size)),
      ),
    );
  }
}
