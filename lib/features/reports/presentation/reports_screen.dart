import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../navigation/widgets/nav_widgets.dart';

/// UI-only selected period for the report range selector.
class ReportPeriodNotifier extends StateNotifier<int> {
  ReportPeriodNotifier() : super(1); // "Today"
  void select(int index) => state = index;
}

final reportPeriodProvider =
    StateNotifierProvider<ReportPeriodNotifier, int>(
  (ref) => ReportPeriodNotifier(),
);

/// Reports screen — analytics layout with KPI cards and chart placeholders.
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  static const List<String> _periods = ['Hourly', 'Today', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePeriod = ref.watch(reportPeriodProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    return ScreenScaffold(
      title: 'Reports',
      actions: [
        SizedBox(
          height: Spacing.buttonHeightSmall,
          child: OutlinedButton.icon(
            onPressed: () {}, // PDF export — future iteration
            icon: Icon(Icons.picture_as_pdf_rounded, size: Spacing.iconSm),
            label: Text(
              'Export PDF',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Period selector
          Row(
            children: [
              for (var i = 0; i < _periods.length; i++)
                Padding(
                  padding: EdgeInsets.only(right: Spacing.sm),
                  child: ChoiceChip(
                    label: Text(
                      _periods[i],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: activePeriod == i
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    selected: activePeriod == i,
                    onSelected: (_) =>
                        ref.read(reportPeriodProvider.notifier).select(i),
                    backgroundColor: AppColors.surfaceVariant,
                    selectedColor: AppColors.primary.withValues(alpha: 0.14),
                  ),
                ),
            ],
          ),
          SizedBox(height: Spacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // KPI grid
                  GridView.count(
                    crossAxisCount: isWide ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: Spacing.md,
                    crossAxisSpacing: Spacing.md,
                    childAspectRatio: 2.4,
                    children: const [
                      _KpiTile(label: 'Gross Sales', value: '\$0.00', icon: Icons.attach_money_rounded),
                      _KpiTile(label: 'Net Profit', value: '\$0.00', icon: Icons.savings_rounded),
                      _KpiTile(label: 'Orders', value: '0', icon: Icons.shopping_cart_rounded),
                      _KpiTile(label: 'Avg. Order', value: '\$0.00', icon: Icons.show_chart_rounded),
                    ],
                  ),
                  SizedBox(height: Spacing.lg),
                  // Charts row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: const _ChartPlaceholder(
                          title: 'Sales Trend',
                          icon: Icons.query_stats_rounded,
                        ),
                      ),
                      if (isWide) SizedBox(width: Spacing.md),
                      if (isWide)
                        const Expanded(
                          flex: 2,
                          child: _ChartPlaceholder(
                            title: 'Payment Methods',
                            icon: Icons.pie_chart_outline_rounded,
                          ),
                        ),
                    ],
                  ),
                  if (!isWide) ...[
                    SizedBox(height: Spacing.md),
                    const _ChartPlaceholder(
                      title: 'Payment Methods',
                      icon: Icons.pie_chart_outline_rounded,
                    ),
                  ],
                  SizedBox(height: Spacing.lg),
                  // Top products table placeholder
                  Card(
                    child: Padding(
                      padding: Spacing.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  size: Spacing.iconMd, color: AppColors.secondary),
                              SizedBox(width: Spacing.sm),
                              Text(
                                'Top Products',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Spacing.md),
                          for (var i = 0; i < 4; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: Spacing.sm),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: AppColors.surfaceVariant,
                                    child: Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Spacing.sm),
                                  Expanded(
                                    child: Container(
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        borderRadius:
                                            BorderRadius.circular(Spacing.radiusSm),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Spacing.md),
                                  Text(
                                    '\$0.00',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSecondary,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Spacing.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: Spacing.iconSm, color: AppColors.primary),
                SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                  ),
                ),
              ],
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
    );
  }
}

class _ChartPlaceholder extends StatelessWidget {
  const _ChartPlaceholder({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Spacing.md),
            Container(
              height: 220.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: Spacing.iconXl, color: AppColors.divider),
                    SizedBox(height: Spacing.sm),
                    Text(
                      'Chart will render here',
                      style:
                          TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
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
