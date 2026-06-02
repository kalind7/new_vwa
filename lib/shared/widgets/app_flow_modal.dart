import 'package:flutter/material.dart';

import '../../config/app_breakpoints.dart';
import '../../config/app_colors.dart';
import '../../config/app_radius.dart';
import '../../config/app_spacing.dart';
import '../../config/app_text_styles.dart';
import 'app_button.dart';

Future<bool> showAppFlowModal({
  required BuildContext context,
  required List<String> messageLines,
  String confirmLabel = 'Yes',
  String cancelLabel = 'No',
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.gray900.withValues(alpha: 0.7),
    builder: (context) {
      return AppFlowModal(
        messageLines: messageLines,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      );
    },
  );

  return result ?? false;
}

class AppFlowModal extends StatelessWidget {
  const AppFlowModal({
    super.key,
    required this.messageLines,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final List<String> messageLines;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.xxl),
      constraints: const BoxConstraints(
        maxWidth: AppBreakpoints.maxMobileContentWidth,
      ),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          AppSpacing.xxxl,
          AppSpacing.xxl,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final line in messageLines) ...[
              Text(
                line,
                textAlign: TextAlign.center,
                style: AppTextStyles.flowModalMessage.copyWith(
                  color: AppColors.gray900,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxxl),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: cancelLabel,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
