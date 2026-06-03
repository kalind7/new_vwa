import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../core/error/failure.dart';

enum AppToastType { success, error, neutral }

class AppToast {
  const AppToast._();

  static void showSuccess(BuildContext context, String message) {
    _show(message, type: AppToastType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(message, type: AppToastType.error);
  }

  /// Shows an API-mapped [Failure] with compact multi-field formatting.
  static void showFailure(BuildContext context, Failure failure) {
    showError(context, failure.message);
  }

  static void showNeutral(BuildContext context, String message) {
    _show(message, type: AppToastType.neutral);
  }

  static void _show(String message, {required AppToastType type}) {
    final backgroundColor = switch (type) {
      AppToastType.success => AppColors.success600,
      AppToastType.error => AppColors.error500,
      AppToastType.neutral => AppColors.gray400,
    };

    final isMultiPartError =
        type == AppToastType.error && message.contains(' · ');
    final duration = isMultiPartError
        ? const Duration(seconds: 4)
        : const Duration(seconds: 3);

    BotToast.showCustomText(
      duration: duration,
      align: Alignment.bottomCenter,
      onlyOne: true,
      toastBuilder: (_) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            maxLines: isMultiPartError ? 3 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMultiPartError ? 13 : 14,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        );
      },
    );
  }
}
