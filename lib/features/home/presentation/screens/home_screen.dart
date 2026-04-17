import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/features/reports/presentation/screens/report_detail_screen.dart';
import 'package:reportes_ai/shared/widgets/app_card.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';
import 'package:reportes_ai/shared/widgets/empty_state.dart';
import 'package:reportes_ai/shared/widgets/report_card.dart';
import 'package:reportes_ai/state/report_provider.dart';
import 'package:reportes_ai/state/session_provider.dart';
import 'package:reportes_ai/features/notifications/presentation/screens/notifications_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final statsAsync = ref.watch(userReportStatsProvider);
    final recentAsync = ref.watch(recentUserReportsProvider(3));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Reportes AI',
        subtitle: 'Panel personal',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context
              , MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              ));
              showModalBottomSheet<void>(
                context: context,
                builder: (sheetContext) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Notificaciones',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text('No tienes notificaciones nuevas por ahora.'),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userReportsProvider);
          ref.invalidate(userReportStatsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          children: [
            Text(
              'Hola, ${session.userName ?? 'Usuario'}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Aquí está el resumen de tu actividad',
              style: Theme.of(context).textTheme.bodyMedium,
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
                  childAspectRatio: 1.4,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tus reportes recientes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
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
                    return ReportCard(
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