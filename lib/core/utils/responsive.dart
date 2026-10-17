import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Design size tuned for landscape tablet POS devices (1280 x 800).
class AppScreenUtil {
  AppScreenUtil._();

  static const double designWidth = 1280;
  static const double designHeight = 800;

  /// Wraps [child] with the ScreenUtil bootstrap so every `.w`, `.h`, `.sp`
  /// and `.r` value scales against the 1280x800 design canvas.
  static Widget wrap({required Widget child}) {
    return ScreenUtilInit(
      designSize: const Size(designWidth, designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => child,
    );
  }
}

/// Responsive spacing / sizing helpers built on top of ScreenUtil.
///
/// Always prefer these over raw pixel values so the layout keeps its rhythm
/// across tablet POS screens.
class Spacing {
  Spacing._();

  // ---- Uniform gaps ----
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 48.w;

  // ---- Page padding ----
  static EdgeInsets get page => EdgeInsets.all(lg);
  static EdgeInsets get pageCompact => EdgeInsets.all(md);

  static EdgeInsets get pageVertical => EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get pageHorizontal => EdgeInsets.symmetric(horizontal: lg);

  // ---- Common combos ----
  static EdgeInsets get cardPadding => EdgeInsets.all(md);
  static EdgeInsets get listItemPadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static EdgeInsets get formItemGap => EdgeInsets.only(bottom: md);

  // ---- Component heights ----
  static double get buttonHeight => 52.h;
  static double get buttonHeightSmall => 40.h;
  static double get inputHeight => 52.h;
  static double get appBarHeight => 64.h;
  static double get navRailWidth => 96.w;
  static double get navDrawerWidth => 280.w;

  // ---- Icon sizes ----
  static double get iconSm => 16.r;
  static double get iconMd => 24.r;
  static double get iconLg => 32.r;
  static double get iconXl => 48.r;

  // ---- Border radius ----
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
}
