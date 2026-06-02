import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/app_colors.dart';

/// Shimmer wrapper matching app gray palette.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray100,
      highlightColor: AppColors.gray50,
      child: child,
    );
  }
}

class AppShimmerBox extends StatelessWidget {
  const AppShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
