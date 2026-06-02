import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';
import '../../../../shared/widgets/app_svg_icon.dart';

class MainBottomNav extends StatelessWidget {
  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const _items = [
    _MainNavItem(label: 'Home', icon: AppSvgIconName.home),
    _MainNavItem(label: 'My wash', icon: AppSvgIconName.wash),
    _MainNavItem(label: 'Profile', icon: AppSvgIconName.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.gray50,
        border: Border(top: BorderSide(color: AppColors.gray300)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.sm,
            AppSpacing.xxl,
            AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var index = 0; index < _items.length; index++)
                _MainBottomNavButton(
                  item: _items[index],
                  isSelected: currentIndex == index,
                  onPressed: () => onChanged(index),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainBottomNavButton extends StatelessWidget {
  const _MainBottomNavButton({
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  final _MainNavItem item;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.brand500 : AppColors.gray400;

    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgIcon(item.icon, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.label,
              style: AppTextStyles.textXsMedium.copyWith(color: color),
            ),
            const SizedBox(height: AppSpacing.xs),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isSelected ? 28 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.brand500,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainNavItem {
  const _MainNavItem({required this.label, required this.icon});

  final String label;
  final AppSvgIconName icon;
}
