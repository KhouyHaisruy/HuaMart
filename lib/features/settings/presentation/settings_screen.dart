import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../navigation/widgets/nav_widgets.dart';

/// UI-only toggles for the settings switches (no persistence yet).
class SettingsTogglesState {
  const SettingsTogglesState({
    this.receiptPrinter = false,
    this.barcodeScanner = true,
    this.lowStockAlerts = true,
    this.darkMode = false,
  });

  final bool receiptPrinter;
  final bool barcodeScanner;
  final bool lowStockAlerts;
  final bool darkMode;

  SettingsTogglesState copyWith({
    bool? receiptPrinter,
    bool? barcodeScanner,
    bool? lowStockAlerts,
    bool? darkMode,
  }) {
    return SettingsTogglesState(
      receiptPrinter: receiptPrinter ?? this.receiptPrinter,
      barcodeScanner: barcodeScanner ?? this.barcodeScanner,
      lowStockAlerts: lowStockAlerts ?? this.lowStockAlerts,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

class SettingsTogglesNotifier extends StateNotifier<SettingsTogglesState> {
  SettingsTogglesNotifier() : super(const SettingsTogglesState());

  void setReceiptPrinter(bool v) => state = state.copyWith(receiptPrinter: v);
  void setBarcodeScanner(bool v) => state = state.copyWith(barcodeScanner: v);
  void setLowStockAlerts(bool v) => state = state.copyWith(lowStockAlerts: v);
  void setDarkMode(bool v) => state = state.copyWith(darkMode: v);
}

final settingsTogglesProvider =
    StateNotifierProvider<SettingsTogglesNotifier, SettingsTogglesState>(
  (ref) => SettingsTogglesNotifier(),
);

/// Settings screen — grouped preference sections in a responsive two-column
/// layout on wide tablets, single column otherwise.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggles = ref.watch(settingsTogglesProvider);
    final notifier = ref.read(settingsTogglesProvider.notifier);
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    final storeCard = _SectionCard(
      title: 'Store Profile',
      icon: Icons.store_rounded,
      children: [
        _SettingRow(
          icon: Icons.location_on_outlined,
          title: 'Store Name',
          subtitle: AppConstants.appName,
          trailing: Icon(Icons.chevron_right_rounded,
              size: Spacing.iconMd, color: AppColors.textSecondary),
          onTap: () {}, // edit dialog — future iteration
        ),
        _SettingRow(
          icon: Icons.currency_yen_outlined,
          title: 'Currency',
          subtitle: '${AppConstants.currencySymbol} USD',
          trailing: Icon(Icons.chevron_right_rounded,
              size: Spacing.iconMd, color: AppColors.textSecondary),
          onTap: () {},
        ),
        _SettingRow(
          icon: Icons.access_time_rounded,
          title: 'Business Hours',
          subtitle: 'Mon–Sat, 8:00 – 20:00',
          trailing: Icon(Icons.chevron_right_rounded,
              size: Spacing.iconMd, color: AppColors.textSecondary),
          onTap: () {},
        ),
      ],
    );

    final hardwareCard = _SectionCard(
      title: 'Hardware',
      icon: Icons.devices_other_rounded,
      children: [
        _SwitchRow(
          icon: Icons.print_rounded,
          title: 'Receipt Printer',
          subtitle: 'Bluetooth thermal printer',
          value: toggles.receiptPrinter,
          onChanged: notifier.setReceiptPrinter,
        ),
        _SwitchRow(
          icon: Icons.qr_code_scanner_rounded,
          title: 'Barcode Scanner',
          subtitle: 'USB / Bluetooth scanner input',
          value: toggles.barcodeScanner,
          onChanged: notifier.setBarcodeScanner,
        ),
      ],
    );

    final alertsCard = _SectionCard(
      title: 'Alerts & Appearance',
      icon: Icons.notifications_active_outlined,
      children: [
        _SwitchRow(
          icon: Icons.warning_amber_rounded,
          title: 'Low Stock Alerts',
          subtitle: 'Notify when items fall below reorder level',
          value: toggles.lowStockAlerts,
          onChanged: notifier.setLowStockAlerts,
        ),
        _SwitchRow(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          subtitle: 'Reduce glare during night shifts',
          value: toggles.darkMode,
          onChanged: notifier.setDarkMode,
        ),
      ],
    );

    final accountCard = _SectionCard(
      title: 'Account',
      icon: Icons.person_rounded,
      children: [
        _SettingRow(
          icon: Icons.manage_accounts_outlined,
          title: 'Manage Users',
          subtitle: 'Cashiers & managers',
          trailing: Icon(Icons.chevron_right_rounded,
              size: Spacing.iconMd, color: AppColors.textSecondary),
          onTap: () {},
        ),
        _SettingRow(
          icon: Icons.lock_reset_rounded,
          title: 'Change PIN',
          subtitle: 'Update your login PIN',
          trailing: Icon(Icons.chevron_right_rounded,
              size: Spacing.iconMd, color: AppColors.textSecondary),
          onTap: () {},
        ),
        _SettingRow(
          icon: Icons.logout_rounded,
          title: 'Sign Out',
          subtitle: 'End the current session',
          onTap: () {}, // sign-out flow — future iteration
          destructive: true,
        ),
      ],
    );

    final List<Widget> sections;
    if (isWide) {
      // Two balanced columns on wide tablet screens.
      sections = [
        Row(
          key: const ValueKey('settings-wide'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: storeCard),
            SizedBox(width: Spacing.md),
            Expanded(child: hardwareCard),
          ],
        ),
        SizedBox(height: Spacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: alertsCard),
            SizedBox(width: Spacing.md),
            Expanded(child: accountCard),
          ],
        ),
      ];
    } else {
      sections = [
        storeCard,
        SizedBox(height: Spacing.md),
        hardwareCard,
        SizedBox(height: Spacing.md),
        alertsCard,
        SizedBox(height: Spacing.md),
        accountCard,
      ];
    }

    return ScreenScaffold(
      title: 'Settings',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: sections,
        ),
      ),
    );
  }
}

/// Wraps a group of setting rows into a titled card.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.sm),
              child: Row(
                children: [
                  Icon(icon, size: Spacing.iconMd, color: AppColors.primary),
                  SizedBox(width: Spacing.sm),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Tappable navigation-style setting row.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.error : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: Spacing.listItemPadding,
        child: Row(
          children: [
            Icon(icon, size: Spacing.iconMd, color: AppColors.textSecondary),
            SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

/// Setting row ending in a switch. Switches only mutate local UI state.
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Row(
        children: [
          SizedBox(width: Spacing.sm),
          Icon(icon, size: Spacing.iconMd, color: AppColors.textSecondary),
          SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
