import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:reportes_ai/features/reports/presentation/screens/report_detail_screen.dart';
import 'package:reportes_ai/shared/widgets/app_card.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';
import 'package:reportes_ai/shared/widgets/empty_state.dart';
import 'package:reportes_ai/shared/widgets/report_card.dart';
import 'package:reportes_ai/state/report_provider.dart';
import 'package:reportes_ai/state/session_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final statsAsync = ref.watch(userReportStatsProvider);
    final recentAsync = ref.watch(recentUserReportsProvider(3));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Reportes AI',
        subtitle: 'Panel personal',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.textSecondary,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          refreshReports(ref);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${session.userName?.split(' ').first ?? 'Usuario'} 👋',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Aquí está el resumen de tu actividad',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            statsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => Text(error.toString()),
              data: (stats) {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.18,
                  children: [
                    StatCard(
                      label: 'Total',
                      value: '${stats.total}',
                      icon: Icons.folder_open_rounded,
                    ),
                    StatCard(
                      label: 'Enviados',
                      value: '${stats.submitted}',
                      icon: Icons.send_rounded,
                    ),
                    StatCard(
                      label: 'En revisión',
                      value: '${stats.reviewing}',
                      icon: Icons.search_rounded,
                    ),
                    StatCard(
                      label: 'Atendidos',
                      value: '${stats.attended}',
                      icon: Icons.check_circle_rounded,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Tus reportes recientes',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            recentAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => Text(error.toString()),
              data: (reports) {
                if (reports.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.article_outlined,
                    title: 'No tienes reportes aún',
                    subtitle:
                        'Crea tu primer reporte para verlo reflejado en el panel.',
                  );
                }

                return Column(
                  children: reports.map((report) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ReportCard(
                        title: report.title,
                        description: report.description,
                        status: report.status,
                        date:
                            '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                        category: report.category,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportDetailScreen(report: report),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}