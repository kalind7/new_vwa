import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_screen.dart';
import '../../data/onboarding_slide.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_slide_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      backgroundColor: AppColors.white,
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 700;

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingSlides.length,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    return OnboardingSlideView(slide: onboardingSlides[index]);
                  },
                ),
              ),
              SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xxl),
              OnboardingIndicator(
                currentIndex: _currentIndex,
                itemCount: onboardingSlides.length,
              ),
              SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xxl),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Column(
                  children: [
                    AppButton(
                      label: 'Sign Up',
                      variant: AppButtonVariant.secondary,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.signUp),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Login',
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.login),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
