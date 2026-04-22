import 'package:flutter/material.dart';
import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/shared/widgets/status_badge.dart';

class NotifTile extends StatelessWidget {
  const NotifTile({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    this.status,
    this.icon,
    this.iconColor,
    this.isRead = false,
    this.onTap,
  });

  final String title;
  final String message;
  final String date;
  final String? status;
  final IconData? icon;
  final Color? iconColor;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatarColor = iconColor ?? AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead
                ? AppColors.surfaceContainerLowest
                : AppColors.primary.withAlpha(8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                  ? AppColors.border
                  : AppColors.primary.withAlpha(50),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: avatarColor.withAlpha(18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.notifications_active_rounded,
                  color: avatarColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: AppColors.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.outline,
                          ),
                        ),
                        if (status != null) ...[
                          const SizedBox(width: 8),
                          StatusBadge(status: status!, showIcon: true),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
