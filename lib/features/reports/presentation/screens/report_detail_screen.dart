import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/data/models/report_model.dart';
import 'package:reportes_ai/shared/widgets/app_card.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';
import 'package:reportes_ai/shared/widgets/primary_button.dart';
import 'package:reportes_ai/state/report_provider.dart';

class ReportDetailScreen extends ConsumerWidget {
  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  final ReportModel report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Detalle del reporte',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(report.category),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Estado: ${report.status}'),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Fecha: ${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(report.description),
                ],
              ),
            ),
            if (report.locationLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubicación',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(report.locationLabel!),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: 'Eliminar reporte',
              backgroundColor: AppColors.errorLight,
              foregroundColor: AppColors.error,
              onPressed: () async {
                await ref.read(reportRepositoryProvider).deleteReport(report.id);
                ref.invalidate(userReportsProvider);
                ref.invalidate(userReportStatsProvider);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}