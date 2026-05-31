import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.indigo600,
      primary: AppColors.indigo600,
      secondary: AppColors.secondary500,
      surface: AppColors.white,
      error: AppColors.error500,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingH1,
        headlineLarge: AppTextStyles.displayPoppins,
        titleLarge: AppTextStyles.textXlSemiBold,
        titleMedium: AppTextStyles.textMdSemiBold,
        bodyLarge: AppTextStyles.textMdRegular,
        bodyMedium: AppTextStyles.textSmRegular,
        labelLarge: AppTextStyles.textMdMedium,
        labelMedium: AppTextStyles.textSmMedium,
        labelSmall: AppTextStyles.textXsMedium,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        titleTextStyle: AppTextStyles.textMdSemiBold,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        labelStyle: AppTextStyles.textXsMedium,
        hintStyle: AppTextStyles.textSmMedium.copyWith(
          color: AppColors.secondary300,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.indigo600),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.error300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.error500),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gray400,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(44),
          textStyle: AppTextStyles.textMdMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}
