import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart' show AppSpacing;

/// Status label constants shared across the app.
abstract final class ReportStatus {
  static const String pending    = 'Pendiente';
  static const String inProgress = 'En Proceso';
  static const String resolved   = 'Resuelto';
  static const String rejected   = 'Rechazado';
}

/// Returns semantic color for each [ReportStatus] value.
extension ReportStatusColor on String {
  Color get statusColor {
    switch (this) {
      case ReportStatus.pending:
        return AppColors.warning;
      case ReportStatus.inProgress:
        return AppColors.info;
      case ReportStatus.resolved:
        return AppColors.success;
      case ReportStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.textDisabled;
    }
  }

  Color get statusBackground {
    switch (this) {
      case ReportStatus.pending:
        return AppColors.warningLight;
      case ReportStatus.inProgress:
        return AppColors.infoLight;
      case ReportStatus.resolved:
        return AppColors.successLight;
      case ReportStatus.rejected:
        return AppColors.errorLight;
      default:
        return AppColors.surfaceVariant;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case ReportStatus.pending:
        return Icons.schedule_rounded;
      case ReportStatus.inProgress:
        return Icons.autorenew_rounded;
      case ReportStatus.resolved:
        return Icons.check_circle_rounded;
      case ReportStatus.rejected:
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}

/// Dynamic Card that displays a single report in a list.
/// If status is 'En Proceso', it renders as a Dark Green card (active aesthetic).
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    this.category,
    this.onTap,
    this.onDismissed,
    this.heroTag,
  });

  final String title;
  final String description;
  final String status;
  final String date;
  final String? category;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Forest Green Dynamic aesthetic logic
    final isActive = status == ReportStatus.inProgress || status == ReportStatus.pending;
    
    final bgColor = isActive ? AppColors.primary : AppColors.surface;
    final titleColor = isActive ? Colors.white : AppColors.textPrimary;
    final bodyColor = isActive ? Colors.white70 : AppColors.textSecondary;
    final iconColor = isActive ? Colors.white : AppColors.textDisabled;
    
    // For the badge, if active, we invert it against the dark green background
    final badgeColor = isActive ? Colors.white : status.statusColor;
    final badgeBgColor = isActive ? Colors.white.withAlpha(40) : status.statusBackground;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
          splashColor: Colors.white.withAlpha(30),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ──────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (category != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              category!,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: bodyColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(status.statusIcon, size: 14, color: badgeColor),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Description ─────────────────────────────────────────────
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(color: bodyColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Footer: date and details link ───────────────────────────
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: iconColor,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      date,
                      style: theme.textTheme.labelMedium?.copyWith(color: iconColor),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white.withAlpha(20) : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        'Más detalles',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
