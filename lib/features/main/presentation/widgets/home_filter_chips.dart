import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_svg_icon.dart';
import '../providers/home_provider.dart';

/// Dev Handoff filter chips: Nearby + Highest slot with less distance + filter icon.
class HomeFilterChips extends StatelessWidget {
  const HomeFilterChips({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onFilterTap,
  });

  final HomeStationTab selectedTab;
  final Future<void> Function(HomeStationTab tab) onTabChanged;
  final VoidCallback onFilterTap;

  static const _chips = [
    (HomeStationTab.nearby, 'Nearby'),
    (HomeStationTab.lessDistance, 'Highest slot with less distance'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.xl,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var index = 0; index < _chips.length; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.sm),
                    _HandoffFilterChip(
                      label: _chips[index].$2,
                      isSelected: selectedTab == _chips[index].$1,
                      onTap: () => onTabChanged(_chips[index].$1),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: AppSvgIcon(
                    AppSvgIconName.filter,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HandoffFilterChip extends StatelessWidget {
  const _HandoffFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.gray700 : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: isSelected ? AppColors.gray700 : AppColors.filterChipBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 10,
          ),
          child: Text(
            label,
            style: AppTextStyles.textXsMedium.copyWith(
              color: isSelected ? AppColors.white : AppColors.gray900,
              letterSpacing: 0.24,
            ),
          ),
        ),
      ),
    );
  }
}
