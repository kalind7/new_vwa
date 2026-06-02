import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_handoff_bottom_sheet.dart';
import '../providers/home_provider.dart';

Future<HomeStationTab?> showHomeFilterBottomSheet({
  required BuildContext context,
  required HomeStationTab selectedTab,
}) {
  return showAppHandoffBottomSheet<HomeStationTab>(
    context: context,
    title: 'Filter',
    child: _HomeFilterSheetContent(selectedTab: selectedTab),
  );
}

class _HomeFilterSheetContent extends StatelessWidget {
  const _HomeFilterSheetContent({required this.selectedTab});

  final HomeStationTab selectedTab;

  static const _options = [
    (HomeStationTab.nearby, 'Nearby'),
    (HomeStationTab.lessDistance, 'Highest slot with less distance'),
    (HomeStationTab.all, 'All stations'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in _options) ...[
          _FilterOptionTile(
            label: option.$2,
            isSelected: selectedTab == option.$1,
            onTap: () => Navigator.of(context).pop(option.$1),
          ),
          if (option != _options.last) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _FilterOptionTile extends StatelessWidget {
  const _FilterOptionTile({
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
      color: isSelected ? AppColors.gray50 : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isSelected ? AppColors.gray700 : AppColors.gray200,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.textMdMedium.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, color: AppColors.gray700, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
