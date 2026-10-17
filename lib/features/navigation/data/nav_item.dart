import 'package:flutter/material.dart';

/// A single entry of the HuaMart POS main navigation rail / drawer.
class NavItem {
  const NavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });

  /// Stable identifier used by the navigation state provider.
  final String id;

  /// Display label shown next to the icon.
  final String label;

  /// Icon rendered when the item is not selected.
  final IconData icon;

  /// Icon rendered when the item is selected.
  final IconData selectedIcon;

  /// Named route this item navigates to.
  final String route;
}

/// Ordered list of primary destinations available from the shell navigation.
const List<NavItem> kPrimaryNavItems = <NavItem>[
  NavItem(
    id: 'pos',
    label: 'POS',
    icon: Icons.point_of_sale_outlined,
    selectedIcon: Icons.point_of_sale,
    route: '/pos',
  ),
  NavItem(
    id: 'products',
    label: 'Products',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    route: '/products',
  ),
  NavItem(
    id: 'inventory',
    label: 'Inventory',
    icon: Icons.pending_actions_outlined,
    selectedIcon: Icons.pending_actions,
    route: '/inventory',
  ),
  NavItem(
    id: 'orders',
    label: 'Orders',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    route: '/orders',
  ),
  NavItem(
    id: 'reports',
    label: 'Reports',
    icon: Icons.insights_outlined,
    selectedIcon: Icons.insights,
    route: '/reports',
  ),
  NavItem(
    id: 'settings',
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    route: '/settings',
  ),
];
