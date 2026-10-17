import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_theme.dart';
export 'app_typography.dart';

/// Barrel file for the theme layer.
///
/// Usage: `import 'package:hua_mart_pos/core/theme/theme.dart';`
class ThemeBarrel {
  ThemeBarrel._(); // no instances — this class only anchors the exports.
}

// Small internal sanity constants so the barrel is never empty of symbols.
const Color kBrandRed = AppColors.primary;
const double kCardRadius = AppTheme.borderRadius;
const String kFontFamily = AppTypography.fontFamily;
