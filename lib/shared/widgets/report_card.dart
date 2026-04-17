import 'package:flutter/material.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';

abstract final class ReportStatus {
  static const String submitted = 'Enviado';
  static const String reviewing = 'En revisión';
  static const String attended = 'Atendido';
}

extension ReportStatusColor on String {
  Color get statusColor {
    switch (this) {
      case ReportStatus.submitted:
        return AppColors.info;
      case ReportStatus.reviewing:
        return AppColors.warning;
      case ReportStatus.attended:
        return AppColors.success;
      default:
        return AppColors.textDisabled;
    }
  }

  Color get statusBackground {
    switch (this) {
      case ReportStatus.submitted:
        return AppColors.infoLight;
      case ReportStatus.reviewing:
        return AppColors.warningLight;
      case ReportStatus.attended:
        return AppColors.successLight;
      default:
        return AppColors.surfaceVariant;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case ReportStatus.submitted:
        return Icons.send_rounded;
      case ReportStatus.reviewing:
        return Icons.search_rounded;
      case ReportStatus.attended:
        return Icons.check_circle_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    this.category,
    this.onTap,
  });

  final String title;
  final String description;
  final String status;
  final String date;
  final String? category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: status.statusBackground,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            status.statusIcon,
                            size: 14,
                            color: status.statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: status.statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      date,
                      style: theme.textTheme.labelMedium,
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