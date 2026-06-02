import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_screen_header.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/booking_flow_mock_data.dart';
import '../../data/main_shell_mock_data.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gray25, width: 2),
                      color: AppColors.gray100,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D101828),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      child: Text(
                        'Add',
                        style: AppTextStyles.textXsMedium.copyWith(
                          color: AppColors.gray700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(
              'Your Profile',
              style: AppTextStyles.textXlSemiBold.copyWith(
                color: AppColors.gray800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const AppTextField(
              label: 'First Name',
              hintText: 'Louis',
              initialValue: 'Louis',
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppTextField(
              label: 'Last Name',
              hintText: 'Becket',
              initialValue: 'Becket',
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppTextField(
              label: 'Email',
              hintText: 'Louisbecket@gmail.com',
              initialValue: 'Louisbecket@gmail.com',
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton(
              label: 'Save changes',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyVehicleScreen extends StatelessWidget {
  const MyVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'My vehicle number'),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        itemCount: vehicles.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.gray25,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                vehicle.plate,
                style: AppTextStyles.textMdMedium.copyWith(
                  color: AppColors.gray700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SavedStationsScreen extends StatelessWidget {
  const SavedStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: 'Saved'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: nearbyStations
            .map(
              (station) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bookmark_outline),
                    title: Text(station.name),
                    subtitle: Text(station.location),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StaticProfileContentScreen(
      title: 'About Us',
      body:
          'Bike wash helps riders discover nearby washing stations, book slots, '
          'and track completed washes.',
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StaticProfileContentScreen(
      title: 'Terms and Conditions',
      body:
          'These terms govern your use of the Bike wash application. '
          'By continuing to use the app, you agree to the published terms.',
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StaticProfileContentScreen(
      title: 'Privacy Policy',
      body:
          'We collect only the information needed to provide booking, payment, '
          'and profile services. Your data is handled according to our privacy policy.',
    );
  }
}

class _StaticProfileContentScreen extends StatelessWidget {
  const _StaticProfileContentScreen({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppScreenHeader(context, title: title),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Text(
          body,
          style: AppTextStyles.textMdRegular.copyWith(
            color: AppColors.gray600,
          ),
        ),
      ),
    );
  }
}
