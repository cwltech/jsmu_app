export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized Responsive Helper Utility using flutter_screenutil.
/// Provides screen queries, adaptive dimensions, responsive value helpers,
/// and re-exports flutter_screenutil extensions (.w, .h, .r, .sp).
class Responsive {
  Responsive._();

  /// Screen Width
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  /// Screen Height
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  /// Check if device is small screen (e.g., width <= 360)
  static bool isSmallPhone(BuildContext context) => MediaQuery.of(context).size.width <= 360;

  /// Check if device is standard mobile (width < 600)
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;

  /// Check if device is tablet (width >= 600)
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  /// Responsive value selector based on device breakpoint
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? smallMobile,
    T? tablet,
  }) {
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    if (isSmallPhone(context) && smallMobile != null) {
      return smallMobile;
    }
    return mobile;
  }

  /// Adaptive edge insets for standard horizontal screen padding
  static EdgeInsets screenPadding([double horizontal = 16, double vertical = 0]) {
    return EdgeInsets.symmetric(
      horizontal: horizontal.w,
      vertical: vertical.h,
    );
  }

  /// Adaptive card border radius
  static BorderRadius radius([double r = 16]) => BorderRadius.circular(r.r);

  /// Sized box vertical spacing
  static Widget gapH(double h) => SizedBox(height: h.h);

  /// Sized box horizontal spacing
  static Widget gapW(double w) => SizedBox(width: w.w);
}
