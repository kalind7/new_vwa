import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_spacing.dart';
import '../../config/app_text_styles.dart';
import 'app_svg_icon.dart';

/// Header with back button placed ~24px below the status bar (Figma-aligned).
class AppScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  static const double _topInset = AppSpacing.xxl;
  static const double _buttonSize = 40;

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  static double toolbarHeight(BuildContext context) {
    return _topInset + _buttonSize + AppSpacing.sm;
  }

  static double totalHeight(BuildContext context) {
    return MediaQuery.paddingOf(context).top + toolbarHeight(context);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + _topInset);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.gray100,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: toolbarHeight(context),
      title: Text(
        title,
        style: AppTextStyles.textLgSemiBold.copyWith(color: AppColors.gray800),
      ),
      centerTitle: true,
      leadingWidth: AppSpacing.lg + _buttonSize,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          top: _topInset,
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: _HeaderIconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
      actions: [
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(
              right: AppSpacing.lg,
              top: _topInset,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: trailing,
            ),
          )
        else
          SizedBox(width: AppSpacing.lg + _buttonSize),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.gray800,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: AppScreenHeader._buttonSize,
          height: AppScreenHeader._buttonSize,
          child: Center(
            child: AppSvgIcon(
              AppSvgIconName.arrowLeft,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps [AppScreenHeader] with a dynamic preferred height for [Scaffold.appBar].
PreferredSizeWidget buildAppScreenHeader(
  BuildContext context, {
  required String title,
  VoidCallback? onBack,
  Widget? trailing,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(AppScreenHeader.totalHeight(context)),
    child: AppScreenHeader(
      title: title,
      onBack: onBack,
      trailing: trailing,
    ),
  );
}
