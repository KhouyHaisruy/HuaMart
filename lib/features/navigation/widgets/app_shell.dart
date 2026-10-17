import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../auth/presentation/login_screen.dart';
import '../../inventory/presentation/inventory_screen.dart';
import '../../orders/presentation/orders_screen.dart';
import '../../pos_home/presentation/pos_home_screen.dart';
import '../../products/presentation/products_screen.dart';
import '../../reports/presentation/reports_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../data/nav_item.dart';
import '../providers/navigation_provider.dart';
import 'nav_widgets.dart';

/// Breakpoint (logical px) under which the side rail collapses into a drawer.
const double _kRailBreakpoint = 720;

/// Application shell: persistent navigation + the selected destination.
///
/// Wide (tablet POS, design 1280x800): icon NavigationRail on the left.
/// Narrow: hamburger opens a labeled NavigationDrawer.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(navIndexProvider);
    final isWide = MediaQuery.sizeOf(context).width >= _kRailBreakpoint;

    void select(int index) {
      ref.read(navIndexProvider.notifier).select(index);
      if (!isWide && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // close the drawer after selecting
      }
    }

    final destination = _ScreenRegistry.screenForIndex(activeIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: isWide
          ? null
          : _NavDrawer(activeIndex: activeIndex, onSelect: select),
      appBar: isWide ? null : const _ShellAppBar(),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide) ...[
              _NavRail(activeIndex: activeIndex, onSelect: select),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.divider,
              ),
            ],
            Expanded(child: destination),
          ],
        ),
      ),
    );
  }
}

/// Icon-only rail sized with ScreenUtil for tablet POS devices.
class _NavRail extends StatelessWidget {
  const _NavRail({required this.activeIndex, required this.onSelect});

  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: false,
      labelType: NavigationRailLabelType.all,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary.withValues(alpha: 0.12),
      selectedIndex: activeIndex,
      onDestinationSelected: onSelect,
      leading: const NavHeader(compact: true),
      groupAlignment: -0.9,
      minWidth: Spacing.navRailWidth,
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: Spacing.md),
            child: Tooltip(
              message: 'Cashier: Demo User',
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.surfaceVariant,
                child: Icon(
                  Icons.person_rounded,
                  size: Spacing.iconMd,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
      destinations: [
        for (final item in kPrimaryNavItems)
          NavigationRailDestination(
            icon: Icon(item.icon, size: Spacing.iconLg),
            selectedIcon: Icon(item.selectedIcon, size: Spacing.iconLg),
            label: Text(
              item.label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: Spacing.sm),
          ),
      ],
    );
  }
}

/// Labeled drawer used on narrow screens.
class _NavDrawer extends ConsumerWidget {
  const _NavDrawer({required this.activeIndex, required this.onSelect});

  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      width: Spacing.navDrawerWidth,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NavHeader(),
            const Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                children: [
                  for (var i = 0; i < kPrimaryNavItems.length; i++)
                    NavDrawerTile(
                      item: kPrimaryNavItems[i],
                      selected: i == activeIndex,
                      onTap: () => onSelect(i),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: Spacing.listItemPadding,
              child: Text(
                '${AppConstants.appName} v1.0.0',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal top bar shown only when the rail collapses into a drawer.
class _ShellAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _ShellAppBar();

  @override
  Size get preferredSize => Size.fromHeight(Spacing.appBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentNavItemProvider);
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: Spacing.sm,
      title: Row(
        children: [
          Icon(current.icon, size: Spacing.iconMd, color: AppColors.primary),
          SizedBox(width: Spacing.sm),
          Text(
            current.label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Maps nav indexes to their screen widget (no routing packages needed —
/// the shell swaps destinations in place, which is standard for POS UIs).
class _ScreenRegistry {
  _ScreenRegistry._();

  static Widget screenForIndex(int index) {
    switch (kPrimaryNavItems[index].id) {
      case 'pos':
        return const PosHomeScreen();
      case 'products':
        return const ProductsScreen();
      case 'inventory':
        return const InventoryScreen();
      case 'orders':
        return const OrdersScreen();
      case 'reports':
        return const ReportsScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const PosHomeScreen();
    }
  }
}
