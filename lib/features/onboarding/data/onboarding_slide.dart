import '../../../config/app_assets.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.assetPath,
  });

  final String title;
  final String description;
  final String assetPath;
}

const onboardingSlides = [
  OnboardingSlide(
    title: 'Find nearby washing station',
    description:
        'Your gateway to finding nearby stations and choosing the right wash for your vehicle.',
    assetPath: AppAssets.shareLocation,
  ),
  OnboardingSlide(
    title: 'Easy payment and offers',
    description:
        'Claim offers, book faster, and pay with supported Nepali wallet options.',
    assetPath: AppAssets.easyPayment,
  ),
  OnboardingSlide(
    title: 'Track your history',
    description:
        'Review every booking, wash status, and service history from one place.',
    assetPath: AppAssets.trackHistory,
  ),
];
