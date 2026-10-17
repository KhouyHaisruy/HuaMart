import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../navigation/widgets/nav_widgets.dart';

/// UI-only filter state for the Orders screen (no order data yet).
class OrderFilterNotifier extends StateNotifier<int?> {
  OrderFilterNotifier() : super(null); // null = "All"
  void select(int? index) => state = index;
}

final orderFilterProvider =
    StateNotifierProvider<OrderFilterNotifier, int?>((ref) => OrderFilterNotifier());

/// Orders screen — sales history layout with status filters.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  static const List<String> _filters = [
    'All',
    'Completed',
    'Pending',
    'Refunded',
    'Voided',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(orderFilterProvider);

    return ScreenScaffold(
      title: 'Orders',
      actions: [
        SizedBox(
          height: Spacing.buttonHeightSmall,
          child: OutlinedButton.icon(
            onPressed: () {}, // export flow — future iteration
            icon: Icon(Icons.download_rounded, size: Spacing.iconSm),
            label: Text(
              'Export',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date range + search toolbar
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: Spacing.inputHeight,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by order # or customer…',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon:
                          Icon(Icons.search_rounded, size: Spacing.iconMd),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Spacing.md),
              _DateRangeButton(),
            ],
          ),
          SizedBox(height: Spacing.md),
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < _filters.length; i++)
                  Padding(
                    padding: EdgeInsets.only(right: Spacing.sm),
                    child: ChoiceChip(
                      label: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: activeFilter == i ||
                                  (activeFilter == null && i == 0)
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      selected: (activeFilter ?? 0) == i,
                      onSelected: (_) =>
                          ref.read(orderFilterProvider.notifier).select(i),
                      backgroundColor: AppColors.surfaceVariant,
                      selectedColor: AppColors.primary.withValues(alpha: 0.14),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: Spacing.md),
          // Order list placeholder
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (_, __) => SizedBox(height: Spacing.sm),
              itemBuilder: (context, index) =>
                  _OrderCardPlaceholder(index: index),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRangeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Spacing.inputHeight,
      child: OutlinedButton.icon(
        onPressed: () {}, // date picker — future iteration
        icon: Icon(Icons.calendar_today_rounded, size: Spacing.iconSm),
        label: Text(
          'Today',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Skeleton row communicating the final order card design.
class _OrderCardPlaceholder extends StatelessWidget {
  const _OrderCardPlaceholder({required this.index});

  /// Placeholder numbering only — real order numbers come with the data layer.
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {}, // order details — future iteration
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        child: Padding(
          padding: Spacing.cardPadding,
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: Spacing.iconLg,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${(1000 + index)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Spacing.xs),
                    Text(
                      '0 items • Payment pending',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Spacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$0.00',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Spacing.xs),
                  Container(
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
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
