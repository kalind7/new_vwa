import 'dart:math' as math;

class AppBreakpoints {
  const AppBreakpoints._();

  static const double figmaDesignWidth = 430;
  static const double maxMobileContentWidth = 430;
  static const double smallPhoneWidth = 360;
  static const double compactHeight = 700;

  static double horizontalPadding(double screenWidth) {
    if (screenWidth <= smallPhoneWidth) return 16;
    return 24;
  }

  static double responsiveImageHeight({
    required double availableHeight,
    required double maxHeight,
    required double minHeight,
  }) {
    return math.max(minHeight, math.min(maxHeight, availableHeight * 0.52));
  }
}
