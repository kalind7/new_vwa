import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

enum AppToastType { success, error, neutral }

class AppToast {
  const AppToast._();

  static void showSuccess(BuildContext context, String message) {
    _show(message, type: AppToastType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(message, type: AppToastType.error);
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

    BotToast.showCustomText(
      duration: const Duration(seconds: 3),
      align: Alignment.bottomCenter,
      onlyOne: true,
      toastBuilder: (_) {
        return Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
