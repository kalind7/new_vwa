import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../data/main_shell_mock_data.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const _ProfileHero(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xxxl,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final section in profileMenuSections) ...[
                          Text(
                            section.title,
                            style: AppTextStyles.textSmMedium.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _ProfileMenuCard(
                            items: section.items,
                            onTap: (route) =>
                                Navigator.of(context).pushNamed(route),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                        _LogoutCard(onTap: () => _confirmLogout(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showAppConfirmationDialog(
      context: context,
      title: 'Log out?',
      message: 'Are you sure you want to log out?',
      confirmLabel: 'Yes',
      cancelLabel: 'No',
    );

    if (shouldLogout && context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.homeGradientStart, AppColors.homeGradientEnd],
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -48),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gray25, width: 2),
                      color: AppColors.gray100,
                    ),
                    child: const AppSvgIcon(
                      AppSvgIconName.profile,
                      size: 44,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Louis Becket',
                style: AppTextStyles.textXlSemiBold.copyWith(
                  color: AppColors.gray800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Vehicle Number',
                style: AppTextStyles.textSmRegular.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuCard extends StatelessWidget {
  const _ProfileMenuCard({required this.items, required this.onTap});

  final List<ProfileMenuItemMock> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D101828),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _ProfileMenuTile(item: items[i], onTap: () => onTap(items[i].route)),
            if (i != items.length - 1)
              const Divider(height: 1, color: AppColors.gray200),
          ],
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({required this.item, required this.onTap});

  final ProfileMenuItemMock item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            AppSvgIcon(item.icon, color: AppColors.gray700, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.textSmMedium.copyWith(
                  color: AppColors.gray800,
                ),
              ),
            ),
            const AppSvgIcon(
              AppSvgIconName.chevronRight,
              color: AppColors.gray400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutCard extends StatelessWidget {
  const _LogoutCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D101828),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const AppSvgIcon(
                AppSvgIconName.arrowLeft,
                color: AppColors.gray600,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Log out',
                style: AppTextStyles.textSmMedium.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
