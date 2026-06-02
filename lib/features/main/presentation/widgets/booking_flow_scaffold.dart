import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_svg_icon.dart';

/// Simple scaffold for booking flow screens (payment method, slot selection, etc.).
class BookingFlowScaffold extends StatelessWidget {
  const BookingFlowScaffold({
    super.key,
    required this.title,
    required this.child,
    this.bottomBar,
    this.backgroundColor = AppColors.white,
  });

  final String title;
  final Widget child;
  final Widget? bottomBar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: AppTextStyles.textLgSemiBold.copyWith(
            color: AppColors.gray800,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Center(
            child: Material(
              color: AppColors.gray800,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: AppSvgIcon(
                      AppSvgIconName.arrowLeft,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
      bottomNavigationBar: bottomBar == null
          ? null
          : ColoredBox(
              color: AppColors.white,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (bottomBar != null) ...[
                        const Divider(height: 1, color: AppColors.gray200),
                        const SizedBox(height: AppSpacing.lg),
                        bottomBar!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
