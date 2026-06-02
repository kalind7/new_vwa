import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Core Figma tokens.
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color canvas = Color(0xFF444444);
  static const Color authDarkBackground = Color(0xFF101828);

  // Gray scale from the Bike-wash Figma file.
  static const Color gray25 = Color(0xFFFCFCFD);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF2F4F7);
  static const Color gray200 = Color(0xFFEAECF0);
  static const Color gray300 = Color(0xFFD0D5DD);
  static const Color gray400 = Color(0xFF98A2B3);
  static const Color gray500 = Color(0xFF667085);
  static const Color gray600 = Color(0xFF475467);
  static const Color gray700 = Color(0xFF344054);
  static const Color gray800 = Color(0xFF182230);
  static const Color gray900 = Color(0xFF101828);
  static const Color gray950 = Color(0xFF0C111D);

  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue600 = Color(0xFF1570EF);
  static const Color blue700 = Color(0xFF155DFC);

  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green600 = Color(0xFF00A63E);
  static const Color green700 = Color(0xFF00C950);

  static const Color brand25 = Color(0xFFFFEEEE);
  static const Color brand50 = Color(0xFFFFFCF5);
  static const Color handoffLabelMuted = Color(0xFF4A5565);

  // App-specific Figma tokens.
  static const Color secondary300 = Color(0xFFACB5BB);
  static const Color secondary400 = Color(0xFF6C7278);
  static const Color secondary500 = Color(0xFF1A1C1E);
  static const Color indigo500 = Color(0xFF6172F3);
  static const Color indigo600 = Color(0xFF444CE7);
  static const Color error300 = Color(0xFFFDA29B);
  static const Color error500 = Color(0xFFF04438);
  static const Color success50 = Color(0xFFECFDF3);
  static const Color success100 = Color(0xFFD1FADF);
  static const Color success200 = Color(0xFFA6F4C5);
  static const Color success600 = Color(0xFF079455);
  static const Color success700 = Color(0xFF027A48);

  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFF2E1);
  static const Color orange600 = Color(0xFFF54900);
  static const Color inputBorder = Color(0xFFEDF1F3);
  static const Color segmentedControl = Color(0xFFF5F6F9);
  static const Color mutedText = Color(0xFF7D7D91);
  static const Color tabText = Color(0xFF232447);
  static const Color logoAccent = Color(0xFFFF5656);
  static const Color brand500 = Color(0xFFFF5656);
  static const Color lightText = Color(0xFFEEEEEE);

  /// Dev Handoff Droplet header gradient (bottom → top).
  static const Color homeGradientStart = Color(0xFF005BEA);
  static const Color homeGradientMid = Color(0xFF80ABF0);
  static const Color homeGradientEnd = Color(0xFFFFFFFF);
  static const Color filterChipBorder = Color(0xFF8D97AD);
  static const Color mapUserLocation = Color(0xFF1A73E8);

  static const LinearGradient homeDropletGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [homeGradientEnd, homeGradientMid, homeGradientStart],
    stops: [0.0, 0.48, 1.0],
  );
}
