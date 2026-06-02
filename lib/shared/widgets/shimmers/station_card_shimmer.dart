import 'package:flutter/material.dart';

import '../../../config/app_radius.dart';
import '../../../config/app_spacing.dart';
import 'app_shimmer.dart';

/// Mirrors [StationCard] layout (152px image + title + meta rows).
class StationCardShimmer extends StatelessWidget {
  const StationCardShimmer({super.key});

  static const _imageHeight = 152.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmerBox(
          width: double.infinity,
          height: _imageHeight,
          borderRadius: AppRadius.md,
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppShimmerBox(
          width: double.infinity,
          height: 22,
          borderRadius: 6,
        ),
        const SizedBox(height: AppSpacing.sm),
        const AppShimmerBox(width: 180, height: 16, borderRadius: 6),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: const [
            AppShimmerBox(width: 72, height: 28, borderRadius: AppRadius.sm),
            SizedBox(width: AppSpacing.md),
            AppShimmerBox(width: 88, height: 28, borderRadius: AppRadius.sm),
            Spacer(),
            AppShimmerBox(width: 64, height: 28, borderRadius: AppRadius.sm),
          ],
        ),
      ],
    );
  }
}

class StationListShimmer extends StatelessWidget {
  const StationListShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 17),
      itemBuilder: (_, _) => const StationCardShimmer(),
    );
  }
}
