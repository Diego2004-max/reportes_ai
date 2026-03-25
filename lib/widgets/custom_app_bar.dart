import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/colors.dart' show AppSpacing;

/// Custom app bar used on every screen.
/// Implements [PreferredSizeWidget] so it plugs into [Scaffold.appBar].
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        AppSpacing.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? AppColors.textPrimary;
    final bg = backgroundColor ?? AppColors.surface;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elevation ?? AppSpacing.elevationNone,
      scrolledUnderElevation: AppSpacing.elevationSm,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: fg,
                ),
              ),
            )
          : leading,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: AppSpacing.sm),
            ]
          : null,
      bottom: bottom,
    );
  }
}
