import 'package:flutter/material.dart';

class ResponsiveLayout {
  /// Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double maxContentWidth = 460.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  static bool isShortScreen(BuildContext context) =>
      MediaQuery.sizeOf(context).height < 700;

  /// Dynamic horizontal padding based on screen width
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return 16.0;
    if (width < 600) return 24.0;
    return 32.0;
  }

  /// Dynamic header height that adjusts to screen height & orientation
  static double headerHeight(BuildContext context, {double defaultRatio = 0.28}) {
    final size = MediaQuery.sizeOf(context);
    final isLand = MediaQuery.orientationOf(context) == Orientation.landscape;

    if (isLand) {
      // In landscape orientation, keep header compact so form fields are visible
      return (size.height * 0.35).clamp(110.0, 160.0);
    }

    if (size.width >= mobileBreakpoint) {
      return 220.0;
    }

    // On portrait mobile, adjust by screen height (clamp between 160 and 260)
    return (size.height * defaultRatio).clamp(160.0, 260.0);
  }

  /// Dynamic vertical spacing between form elements
  static double verticalSpacing(BuildContext context, {double defaultValue = 20.0}) {
    if (isShortScreen(context) || isLandscape(context)) {
      return defaultValue * 0.75;
    }
    return defaultValue;
  }
}

