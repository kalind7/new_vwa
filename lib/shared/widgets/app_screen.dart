import 'package:flutter/material.dart';

import '../../config/app_breakpoints.dart';
import '../../config/app_colors.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.padding,
    this.extendBodyBehindSafeArea = false,
    this.constrainToMobileWidth = true,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool extendBodyBehindSafeArea;
  final bool constrainToMobileWidth;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final resolvedPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: AppBreakpoints.horizontalPadding(screenWidth),
        );

    Widget body = Padding(padding: resolvedPadding, child: child);
    if (constrainToMobileWidth) {
      body = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxMobileContentWidth,
          ),
          child: body,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: extendBodyBehindSafeArea ? body : SafeArea(child: body),
    );
  }
}
