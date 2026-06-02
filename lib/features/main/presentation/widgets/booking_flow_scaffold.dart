import 'package:flutter/material.dart';

import '../../../../config/app_breakpoints.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../shared/widgets/app_screen_header.dart';

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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = AppBreakpoints.horizontalPadding(screenWidth);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppScreenHeader(context, title: title),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSpacing.xxl,
              horizontalPadding,
              AppSpacing.xxl,
            ),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: bottomBar == null
          ? null
          : SafeArea(
              minimum: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.sm,
                horizontalPadding,
                AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppBreakpoints.maxMobileContentWidth,
                  ),
                  child: bottomBar,
                ),
              ),
            ),
    );
  }
}
