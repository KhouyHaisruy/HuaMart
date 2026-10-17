import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/nav_item.dart';

/// Index of the currently selected destination inside [kPrimaryNavItems].
///
/// Pure UI state — no business logic lives here.
class NavIndexNotifier extends StateNotifier<int> {
  NavIndexNotifier() : super(_defaultIndex);

  static const int _defaultIndex = 0; // POS Home

  /// Select the item at [index], clamped to a valid range.
  void select(int index) {
    if (index < 0 || index >= kPrimaryNavItems.length) return;
    state = index;
  }

  /// Select the item matching [NavItem.id].
  void selectById(String id) {
    final index = kPrimaryNavItems.indexWhere((item) => item.id == id);
    if (index != -1) state = index;
  }
}

/// Exposes the active navigation index to the whole widget tree.
final navIndexProvider = StateNotifierProvider<NavIndexNotifier, int>(
  (ref) => NavIndexNotifier(),
);

/// Convenience: the currently selected [NavItem].
final currentNavItemProvider = Provider<NavItem>((ref) {
  final index = ref.watch(navIndexProvider);
  return kPrimaryNavItems[index];
});
