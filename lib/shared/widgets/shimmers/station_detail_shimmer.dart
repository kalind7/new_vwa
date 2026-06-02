import 'package:flutter/material.dart';

import '../../../config/app_radius.dart';
import '../../../config/app_spacing.dart';
import 'app_shimmer.dart';

class StationDetailShimmer extends StatelessWidget {
  const StationDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: AppShimmerBox(
            width: double.infinity,
            height: 277,
            borderRadius: 0,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xxl,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const AppShimmerBox(
                width: double.infinity,
                height: 120,
                borderRadius: AppRadius.md,
              ),
              const SizedBox(height: AppSpacing.lg),
              const AppShimmerBox(
                width: double.infinity,
                height: 160,
                borderRadius: AppRadius.md,
              ),
              const SizedBox(height: AppSpacing.lg),
              const AppShimmerBox(
                width: double.infinity,
                height: 100,
                borderRadius: AppRadius.md,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
