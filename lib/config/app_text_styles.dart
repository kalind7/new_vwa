import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get headingH1 => GoogleFonts.inter(
    fontSize: 32,
    height: 1.30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
    color: AppColors.gray900,
  );

  static TextStyle get displayPoppins => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
  );

  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
  );

  static TextStyle get textXlSemiBold => GoogleFonts.poppins(
    fontSize: 20,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: AppColors.gray800,
  );

  static TextStyle get textLgSemiBold => GoogleFonts.inter(
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.gray800,
  );

  static TextStyle get textLgMedium => GoogleFonts.poppins(
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w500,
    color: AppColors.gray950,
  );

  static TextStyle get displayXsSemiBold => GoogleFonts.inter(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
  );

  static TextStyle get flowModalMessage => GoogleFonts.poppins(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: AppColors.gray900,
  );

  static TextStyle get textMdSemiBold => GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
  );

  static TextStyle get textMdMedium => GoogleFonts.poppins(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary500,
  );

  static TextStyle get textMdRegular => GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.gray600,
  );

  static TextStyle get textSmMedium => GoogleFonts.poppins(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary500,
  );

  static TextStyle get textSmRegular => GoogleFonts.inter(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray600,
  );

  static TextStyle get bodySmallRegular => GoogleFonts.inter(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.14,
    color: AppColors.secondary400,
  );

  static TextStyle get textXsMedium => GoogleFonts.poppins(
    fontSize: 12,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary400,
  );

  static TextStyle get textXsSemiBold => GoogleFonts.inter(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.12,
    color: AppColors.gray900,
  );

  static TextStyle get statusBar => const TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.white,
  );
}
