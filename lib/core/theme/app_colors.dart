import 'package:flutter/material.dart';

/// Central colour palette for HuaMart POS.
///
/// Keep every raw hex value here so themes and features never hard-code
/// colours directly.
class AppColors {
  AppColors._();

  // ---- Brand ----
  static const Color primary = Color(0xFFC62828); // HuaMart red
  static const Color primaryDark = Color(0xFF8E0000);
  static const Color primaryLight = Color(0xFFFF5F52);
  static const Color secondary = Color(0xFFF9A825); // warm accent
  static const Color secondaryDark = Color(0xFFC17900);
  static const Color secondaryLight = Color(0xFFFFDA66);

  // ---- Surfaces ----
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF000000);

  // ---- Feedback ----
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFB3261E);
  static const Color info = Color(0xFF0288D1);

  // ---- Lines & dividers ----
  static const Color divider = Color(0xFFE0E0E0);
  static const Color outline = Color(0xFF79747E);

  // ---- Dark theme surfaces ----
  static const Color darkBackground = Color(0xFF17151A);
  static const Color darkSurface = Color(0xFF211F26);
  static const Color darkSurfaceVariant = Color(0xFF36343B);
}
