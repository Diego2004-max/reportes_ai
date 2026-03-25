import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/colors.dart' show AppSpacing;

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
        return AppColors.primary;
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

/// Card that displays a single report in a list.
/// All colors and spacing come from design tokens.
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
    final statusColor = status.statusColor;
    final statusBg = status.statusBackground;
    final statusIc = status.statusIcon;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          splashColor: AppColors.primaryLight.withAlpha(20),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ──────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category icon
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: const Icon(
                        Icons.article_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Title + category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (category != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              category!,
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Status badge
                    _StatusBadge(
                      label: status,
                      color: statusColor,
                      background: statusBg,
                      icon: statusIc,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Description ─────────────────────────────────────────────
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Footer: date ─────────────────────────────────────────────
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      date,
                      style: theme.textTheme.labelSmall,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.textDisabled,
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

// ── Internal badge widget ─────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.background,
    required this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
