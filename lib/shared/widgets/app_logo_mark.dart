import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_radius.dart';
import '../../config/app_text_styles.dart';
import 'app_svg_icon.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key, this.showText = true});

  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.indigo600,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: const AppSvgIcon(
            AppSvgIconName.wash,
            color: AppColors.white,
            size: 22,
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'VWA',
            style: AppTextStyles.textXlSemiBold.copyWith(
              color: AppColors.gray25,
            ),
          ),
        ],
      ],
    );
  }
}
