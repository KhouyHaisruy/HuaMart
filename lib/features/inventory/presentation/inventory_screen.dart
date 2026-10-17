import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../navigation/widgets/nav_widgets.dart';

/// Selected tab index of the Inventory segmented control (UI only).
class InventoryTabNotifier extends StateNotifier<int> {
  InventoryTabNotifier() : super(0);
  void select(int index) => state = index;
}

final inventoryTabProvider =
    StateNotifierProvider<InventoryTabNotifier, int>(
  (ref) => InventoryTabNotifier(),
);

/// Inventory screen — stock overview layout with summary strip and tabs.
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  static const List<String> _tabs = [
    'Stock Levels',
    'Low Stock',
    'Stock Movements',
    'Suppliers',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(inventoryTabProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    return ScreenScaffold(
      title: 'Inventory',
      actions: [
        SizedBox(
          height: Spacing.buttonHeightSmall,
          child: OutlinedButton.icon(
            onPressed: () {}, // stock adjustment flow — future iteration
            icon: Icon(Icons.edit_note_rounded, size: Spacing.iconSm),
            label: Text(
              'Adjust Stock',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(width: Spacing.sm),
        SizedBox(
          height: Spacing.buttonHeightSmall,
          child: ElevatedButton.icon(
            onPressed: () {}, // receive-stock flow — future iteration
            icon: Icon(Icons.inventory_rounded, size: Spacing.iconSm),
            label: Text(
              'Receive Stock',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary strip
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: Spacing.md,
            crossAxisSpacing: Spacing.md,
            childAspectRatio: 2.6,
            children: const [
              _SummaryTile(label: 'Total SKUs', value: '0', color: AppColors.info),
              _SummaryTile(
                  label: 'In Stock', value: '0', color: AppColors.success),
              _SummaryTile(
                  label: 'Low Stock', value: '0', color: AppColors.warning),
              _SummaryTile(
                  label: 'Out of Stock', value: '0', color: AppColors.error),
            ],
          ),
          SizedBox(height: Spacing.lg),
          // Segmented tabs
          Row(
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Padding(
                  padding: EdgeInsets.only(right: Spacing.sm),
                  child: ChoiceChip(
                    label: Text(
                      _tabs[i],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight:
                            activeTab == i ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    selected: activeTab == i,
                    onSelected: (_) =>
                        ref.read(inventoryTabProvider.notifier).select(i),
                    backgroundColor: AppColors.surfaceVariant,
                    selectedColor: AppColors.primary.withValues(alpha: 0.14),
                  ),
                ),
            ],
          ),
          SizedBox(height: Spacing.md),
          // Table-style placeholder list
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    color: AppColors.surfaceVariant,
                    padding: Spacing.listItemPadding,
                    child: Row(
                      children: [
                        _TableHeader('Product', flex: 4),
                        _TableHeader('SKU', flex: 2),
                        _TableHeader('On Hand', flex: 2, align: TextAlign.end),
                        _TableHeader('Reorder At', flex: 2, align: TextAlign.end),
                        _TableHeader('Status', flex: 2, align: TextAlign.end),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: 8,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: AppColors.divider),
                      itemBuilder: (context, index) =>
                          const _InventoryRowPlaceholder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Spacing.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: Spacing.xs),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.text, {this.flex = 1, this.align = TextAlign.start});

  final String text;
  final int flex;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _InventoryRowPlaceholder extends StatelessWidget {
  const _InventoryRowPlaceholder();

  Widget _bar(double width) => Container(
        height: 10.h,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(Spacing.radiusSm),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Spacing.listItemPadding,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Icon(Icons.check_box_outline_blank_rounded,
                    size: Spacing.iconMd, color: AppColors.divider),
                SizedBox(width: Spacing.sm),
                _bar(140.w),
              ],
            ),
          ),
          Expanded(flex: 2, child: _bar(70.w)),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: _bar(30.w))),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: _bar(30.w))),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Text(
                  '—',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
