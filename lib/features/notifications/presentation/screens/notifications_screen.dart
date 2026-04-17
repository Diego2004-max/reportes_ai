import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/data/models/report_model.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';
import 'package:reportes_ai/shared/widgets/empty_state.dart';
import 'package:reportes_ai/state/report_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(userReportsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Notificaciones',
        showBack: true,
      ),
      body: reportsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        data: (reports) {
          if (reports.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'Sin notificaciones',
              subtitle:
                  'Cuando tengas actividad en tus reportes, aparecerá aquí.',
            );
          }

          final items = reports.take(10).toList();

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final report = items[index];
              return _NotificationTile(report: report);
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.report});

  final ReportModel report;

  @override
  Widget build(BuildContext context) {
    final message = switch (report.status) {
      'Enviado' =>
        'Tu reporte fue enviado correctamente y está pendiente de revisión.',
      'En revisión' =>
        'Tu reporte está siendo revisado por el sistema o el equipo responsable.',
      'Atendido' =>
        'Tu reporte fue marcado como atendido.',
      _ => 'Tu reporte tuvo una actualización reciente.',
    };

    final icon = switch (report.status) {
      'Enviado' => Icons.send_rounded,
      'En revisión' => Icons.search_rounded,
      'Atendido' => Icons.check_circle_rounded,
      _ => Icons.notifications_outlined,
    };

    final color = switch (report.status) {
      'Enviado' => AppColors.info,
      'En revisión' => AppColors.warning,
      'Atendido' => AppColors.success,
      _ => AppColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withAlpha(30),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textDisabled,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}