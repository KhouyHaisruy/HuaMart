import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography scale for HuaMart POS.
///
/// A POS is operated on touch screens and in bright shop lighting, so the
/// base text size runs slightly larger than the Material default.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  static TextTheme buildTextTheme({Brightness brightness = Brightness.light}) {
    final Color primaryText =
        brightness == Brightness.light ? AppColors.textPrimary : Colors.white;
    final Color secondaryText = brightness == Brightness.light
        ? AppColors.textSecondary
        : const Color(0xFFCAC4D0);

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      displayMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: secondaryText,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primaryText,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: secondaryText,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: secondaryText,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
    );
  }
}
