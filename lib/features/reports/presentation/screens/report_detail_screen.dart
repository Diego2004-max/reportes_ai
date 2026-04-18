import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  bool get _showSecondaryCoordinates {
    if (report.latitude == null || report.longitude == null) return false;
    if (report.locationLabel == null) return true;
    return !report.locationLabel!.startsWith('Lat ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    style: theme.textTheme.titleLarge,
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
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(report.description),
                ],
              ),
            ),
            if (report.locationLabel != null ||
                report.latitude != null ||
                report.longitude != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubicación',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (report.locationLabel != null) Text(report.locationLabel!),
                    if (_showSecondaryCoordinates) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Lat: ${report.latitude!.toStringAsFixed(5)} | Lng: ${report.longitude!.toStringAsFixed(5)}',
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (report.audioPath != null &&
                report.audioPath!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio adjunto',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Este reporte contiene una grabación de voz guardada.',
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: 'Eliminar reporte',
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.error,
              onPressed: () async {
                await ref.read(reportRepositoryProvider).deleteReport(report.id);
                refreshReports(ref);

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