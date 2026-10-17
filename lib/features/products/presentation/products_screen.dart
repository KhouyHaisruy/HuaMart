import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../navigation/widgets/nav_widgets.dart';

/// UI-only search query state for the Products screen.
class ProductSearchNotifier extends StateNotifier<String> {
  ProductSearchNotifier() : super('');
  void update(String value) => state = value;
}

final productSearchProvider =
    StateNotifierProvider<ProductSearchNotifier, String>(
  (ref) => ProductSearchNotifier(),
);

/// Products screen — catalog grid layout (data & CRUD come later).
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(productSearchProvider);
    // Responsive column count based on available width of the content area.
    final columns = (MediaQuery.sizeOf(context).width / 240).floor().clamp(3, 7);

    return ScreenScaffold(
      title: 'Products',
      actions: [
        SizedBox(
          height: Spacing.buttonHeightSmall,
          child: ElevatedButton.icon(
            onPressed: () {}, // add-product flow — future iteration
            icon: Icon(Icons.add_rounded, size: Spacing.iconSm),
            label: Text(
              'Add Product',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: Spacing.md),
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search + filter toolbar
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: Spacing.inputHeight,
                  child: TextField(
                    onChanged: (v) =>
                        ref.read(productSearchProvider.notifier).update(v),
                    decoration: InputDecoration(
                      hintText: query.isEmpty
                          ? 'Search products…'
                          : 'Searching “$query”',
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
              _ToolbarIconButton(
                icon: Icons.filter_list_rounded,
                tooltip: 'Filter',
              ),
              SizedBox(width: Spacing.sm),
              _ToolbarIconButton(
                icon: Icons.sort_rounded,
                tooltip: 'Sort',
              ),
            ],
          ),
          SizedBox(height: Spacing.md),
          // Category chips (static placeholders)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _CategoryChip(label: 'All', selected: true),
                _CategoryChip(label: 'Beverages'),
                _CategoryChip(label: 'Snacks'),
                _CategoryChip(label: 'Household'),
                _CategoryChip(label: 'Personal Care'),
                _CategoryChip(label: 'Groceries'),
              ],
            ),
          ),
          SizedBox(height: Spacing.md),
          // Product grid placeholder — empty tiles show the intended layout
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: Spacing.md,
                crossAxisSpacing: Spacing.md,
                childAspectRatio: 0.78,
              ),
              // Static skeleton: 3 rows worth of placeholder cards
              itemCount: columns * 3,
              itemBuilder: (context, index) => const _ProductPlaceholderCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({required this.icon, required this.tooltip});

  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        child: InkWell(
          onTap: () {}, // filters/sorting arrive with real data layer
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          child: SizedBox(
            width: Spacing.inputHeight,
            height: Spacing.inputHeight,
            child: Icon(icon, size: Spacing.iconMd, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Spacing.sm),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: selected,
        onSelected: (_) {}, // category filtering — future iteration
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary.withValues(alpha: 0.14),
        labelPadding: EdgeInsets.symmetric(horizontal: Spacing.sm),
      ),
    );
  }
}

/// Skeleton card communicating the final product tile design.
class _ProductPlaceholderCard extends StatelessWidget {
  const _ProductPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.surfaceVariant,
              child: Icon(
                Icons.image_outlined,
                size: Spacing.iconXl,
                color: AppColors.divider,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                ),
                SizedBox(height: Spacing.xs),
                Container(
                  height: 10.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                ),
                SizedBox(height: Spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$0.00',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(
                      Icons.add_shopping_cart_rounded,
                      size: Spacing.iconMd,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
