import 'package:flutter/material.dart';

import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../data/onboarding_slide.dart';

class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({super.key, required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < AppBreakpoints.compactHeight;
        final imageHeight = AppBreakpoints.responsiveImageHeight(
          availableHeight: constraints.maxHeight,
          maxHeight: isCompact ? 260 : 340,
          minHeight: 180,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: imageHeight,
                child: Center(
                  child: Image.asset(
                    slide.assetPath,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: isCompact ? AppSpacing.xl : AppSpacing.xxxl),
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.textXlSemiBold.copyWith(
                  color: AppColors.gray800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                slide.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.textSmRegular.copyWith(
                  color: AppColors.gray600,
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
