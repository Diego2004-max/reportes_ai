import 'package:flutter/material.dart';
import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fg =
        foregroundColor ?? theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface;
    final bg =
        backgroundColor ?? theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1B2940) : Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: isDark ? const Color(0xFF26364D) : AppColors.border,
                  ),
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            )
          : Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
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