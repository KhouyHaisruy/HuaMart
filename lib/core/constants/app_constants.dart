/// Global, application-wide constants for HuaMart POS.
class AppConstants {
  AppConstants._();

  /// Human readable application name.
  static const String appName = 'HuaMart POS';

  /// Short name used in compact UI places (app bar tiles, receipts).
  static const String appShortName = 'HuaMart';

  /// Default locale used by `intl` formatting (currency, dates, numbers).
  static const String defaultLocale = 'en_US';

  /// Currency symbol used across the POS.
  static const String currencySymbol = '\$';

  /// Database file name (Drift / SQLite) stored via `path_provider`.
  static const String databaseName = 'huamart_pos.db';

  /// Page transition duration.
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);
}
