import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/app_breakpoints.dart';
import '../../config/app_colors.dart';
import '../../config/app_radius.dart';
import '../../config/app_spacing.dart';
import '../../config/app_text_styles.dart';

/// Dev Handoff bottom sheet: blurred overlay, 12px top radius, optional centered title.
Future<T?> showAppHandoffBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    // isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.gray950.withValues(alpha: 0.7),
    builder: (context) {
      return AppHandoffBottomSheet(title: title, child: child);
    },
  );
}

class AppHandoffBottomSheet extends StatelessWidget {
  const AppHandoffBottomSheet({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppBreakpoints.maxMobileContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppBreakpoints.horizontalPadding(width),
                  right: AppBreakpoints.horizontalPadding(width),
                  bottom: AppSpacing.lg + bottomInset,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.md),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        offset: Offset(0, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xxl,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (title != null) ...[
                          Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.displayPoppins.copyWith(
                              color: AppColors.gray950,
                              height: 30 / 32,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
