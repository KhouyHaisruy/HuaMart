import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// Static quick-action definitions (layout only — no business logic).
class _QuickAction {
  const _QuickAction(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

const List<_QuickAction> _quickActions = [
  _QuickAction('New Sale', Icons.add_shopping_cart_rounded, AppColors.primary),
  _QuickAction('Hold Orders', Icons.pause_circle_outline_rounded, AppColors.info),
  _QuickAction('Open Drawer', Icons.lock_open_rounded, AppColors.secondary),
  _QuickAction('Shift Report', Icons.calculate_outlined, AppColors.success),
];

/// UI-only state for the home header search field.
class HomeSearchNotifier extends StateNotifier<String> {
  HomeSearchNotifier() : super('');
  void update(String value) => state = value;
}

final homeSearchProvider =
    StateNotifierProvider<HomeSearchNotifier, String>((ref) => HomeSearchNotifier());

/// POS Home screen — dashboard-style landing page inside the app shell.
class PosHomeScreen extends ConsumerWidget {
  const PosHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Number of stat tiles adapts to available width.
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HomeHeader(query: ref.watch(homeSearchProvider)),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.md,
              Spacing.lg,
              Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatRow(compact: !isWide),
                SizedBox(height: Spacing.lg),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: Spacing.md),
                GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: Spacing.md,
                  crossAxisSpacing: Spacing.md,
                  childAspectRatio: 2.1,
                  children: [
                    for (final action in _quickActions)
                      _QuickActionCard(action: action),
                  ],
                ),
                SizedBox(height: Spacing.lg),
                const _RecentActivityCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Greeting + global product search bar.
class _HomeHeader extends ConsumerWidget {
  const _HomeHeader({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Good day, Cashier 👋',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: Spacing.lg),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: Spacing.inputHeight,
              child: TextField(
                onChanged: (v) =>
                    ref.read(homeSearchProvider.notifier).update(v),
                decoration: InputDecoration(
                  hintText: 'Search products by name or barcode…',
                  hintStyle:
                      TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                  prefixIcon:
                      Icon(Icons.search_rounded, size: Spacing.iconMd),
                  isDense: false,
                ),
              ),
            ),
          ),
          SizedBox(width: Spacing.md),
          IconButton(
            onPressed: () {}, // scanner — future iteration
            tooltip: 'Scan barcode',
            icon: Icon(
              Icons.qr_code_scanner_rounded,
              size: Spacing.iconLg,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of headline "cards" with placeholder figures.
class _StatRow extends StatelessWidget {
  const _StatRow({required this.compact});

  final bool compact;

  static const List<(String, String, IconData)> _stats = [
    ('Sales Today', '\$0.00', Icons.trending_up_rounded),
    ('Transactions', '0', Icons.receipt_rounded),
    ('Items Sold', '0', Icons.shopping_bag_rounded),
    ('Low Stock', '0', Icons.warning_amber_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: compact ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Spacing.md,
      crossAxisSpacing: Spacing.md,
      childAspectRatio: 2.4,
      children: [
        for (final (label, value, icon) in _stats)
          Card(
            child: Padding(
              padding: Spacing.cardPadding,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius:
                          BorderRadius.circular(Spacing.radiusSm),
                    ),
                    child: Icon(icon, size: Spacing.iconLg, color: AppColors.primary),
                  ),
                  SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: Spacing.xs),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Large tap target used to jump into common flows.
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {}, // navigation intent — wired up with real flows later
        child: Padding(
          padding: Spacing.cardPadding,
          child: Row(
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                ),
                child: Icon(action.icon, size: Spacing.iconLg, color: action.color),
              ),
              SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  action.label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: Spacing.iconSm,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty-state card standing in for the upcoming activity feed.
class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded,
                    size: Spacing.iconMd, color: AppColors.primary),
                SizedBox(width: Spacing.sm),
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: Spacing.md),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.xl),
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: Spacing.iconXl, color: AppColors.divider),
                    SizedBox(height: Spacing.sm),
                    Text(
                      'No activity yet — sales will appear here.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
