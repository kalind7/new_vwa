import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_confirmation_dialog.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/profile_avatar.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../data/main_shell_mock_data.dart';
import '../providers/main_shell_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _onMenuTap(BuildContext context, ProfileMenuItemMock item) {
    if (item.route == AppProfileRoutes.washHistoryTab) {
      context.read<MainShellProvider>().setTab(1);
      return;
    }
    Navigator.of(context).pushNamed(item.route);
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
      final result = await context.read<AuthRepository>().logout();
      if (!context.mounted) {
        return;
      }

      result.fold((failure) => AppToast.showError(context, failure.message), (
        _,
      ) {
        context.read<UserProfileProvider>().clear();
        AppToast.showSuccess(context, 'Logged out successfully.');
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _ProfileHero()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
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
                      onTap: (item) => _onMenuTap(context, item),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  _LogoutCard(onTap: () => _confirmLogout(context)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    final displayName = profileProvider.displayName;
    final avatarUrl = profileProvider.avatarUrl;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 108,
          color: AppColors.brand25,
        ),
        Transform.translate(
          offset: const Offset(0, -60),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gray25, width: 2),
                  color: AppColors.gray100,
                ),
                child: ClipOval(
                  child: ProfileAvatar(avatarUrl: avatarUrl, size: 120),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                displayName,
                style: AppTextStyles.textXlSemiBold.copyWith(
                  color: AppColors.gray800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ProfileMenuCard extends StatelessWidget {
  const _ProfileMenuCard({required this.items, required this.onTap});

  final List<ProfileMenuItemMock> items;
  final ValueChanged<ProfileMenuItemMock> onTap;

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
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              _ProfileMenuTile(item: items[i], onTap: () => onTap(items[i])),
              if (i != items.length - 1)
                const Divider(height: 1, color: AppColors.gray200),
            ],
          ],
        ),
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
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            AppSvgIcon(item.icon, color: AppColors.gray800, size: 20),
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
                AppSvgIconName.logOut,
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
