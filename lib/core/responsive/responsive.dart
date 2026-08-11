import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return 16;
    }

    if (width < tabletBreakpoint) {
      return 32;
    }

    return 48;
  }

  static double contentMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    }

    if (isTablet(context)) {
      return 800;
    }

    return 1100;
  }

  static double cardMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    }

    if (isTablet(context)) {
      return 700;
    }

    return 900;
  }
}
