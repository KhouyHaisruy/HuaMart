import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../data/nav_item.dart';

/// Brand header shown at the top of the navigation rail / drawer.
class NavHeader extends StatelessWidget {
  const NavHeader({super.key, this.compact = false});

  /// Compact mode hides the label (used inside the icon-only rail).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? Spacing.xs : Spacing.md,
        vertical: Spacing.md,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            child: Icon(
              Icons.storefront_rounded,
              size: Spacing.iconMd,
              color: AppColors.textOnPrimary,
            ),
          ),
          if (!compact) ...[
            SizedBox(width: Spacing.sm),
            Flexible(
              child: Text(
                AppConstants.appShortName,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A single tappable row inside the navigation drawer.
class NavDrawerTile extends StatelessWidget {
  const NavDrawerTile({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusMd),
      child: Container(
        height: Spacing.buttonHeightSmall,
        margin: EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 2.h),
        padding: Spacing.listItemPadding,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              selected ? item.selectedIcon : item.icon,
              size: Spacing.iconMd,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder body used by screens that are not implemented yet.
class PlaceholderBody extends StatelessWidget {
  const PlaceholderBody({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: Spacing.iconXl, color: AppColors.primary),
          ),
          SizedBox(height: Spacing.lg),
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: Spacing.sm),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.xl),
            child: Text(
              subtitle ?? 'This screen is under construction.\n'
                  'Business logic will be added in a later iteration.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Standard page scaffold for every secondary screen (Products, Inventory…).
class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page header
        Padding(
          padding: EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.lg,
            Spacing.lg,
            Spacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
        // Page body
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg,
              0,
              Spacing.lg,
              Spacing.lg,
            ),
            child: body,
          ),
        ),
      ],
    );
  }
}
