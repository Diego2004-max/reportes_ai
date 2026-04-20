import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/data/models/report_model.dart';
import 'package:reportes_ai/shared/widgets/app_card.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';
import 'package:reportes_ai/shared/widgets/primary_button.dart';
import 'package:reportes_ai/state/report_provider.dart';
import 'package:reportes_ai/state/session_provider.dart';

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _buildExpirationLabel() {
    final expiresAt = report.expiresAt;
    if (expiresAt == null) {
      return 'Este reporte no tiene fecha de eliminación configurada.';
    }

    final now = DateTime.now();
    final difference = expiresAt.difference(now);

    if (difference.inSeconds <= 0) {
      return 'Este reporte vence hoy y será eliminado automáticamente.';
    }

    final daysLeft = (difference.inHours / 24).ceil();

    if (daysLeft == 1) {
      return 'Este reporte se elimina en 1 día.';
    }

    return 'Este reporte se elimina en $daysLeft días.';
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar reporte'),
          content: const Text(
            '¿Seguro que quieres eliminar este reporte? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await ref.read(reportRepositoryProvider).deleteReport(report.id);
    refreshReports(ref);

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte eliminado correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(sessionProvider);
    final hasImage = report.imagePaths.isNotEmpty;
    final canDelete = session.userId == report.userId;

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
                  Text('Fecha: ${_formatDate(report.createdAt)}'),
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
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vigencia del reporte',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(_buildExpirationLabel()),
                  if (report.expiresAt != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Fecha límite: ${_formatDate(report.expiresAt!)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
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
            if (hasImage) ...[
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Imagen adjunta',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _ReportImagePreview(imagePath: report.imagePaths.first),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Row(
                children: [
                  Icon(
                    canDelete ? Icons.verified_user_outlined : Icons.lock_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      canDelete
                          ? 'Tú creaste este reporte. Puedes eliminarlo antes de su vencimiento.'
                          : 'Solo el usuario que creó este reporte puede eliminarlo.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (canDelete) ...[
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Eliminar reporte',
                backgroundColor: theme.colorScheme.errorContainer,
                foregroundColor: theme.colorScheme.error,
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReportImagePreview extends StatelessWidget {
  const _ReportImagePreview({
    required this.imagePath,
  });

  final String imagePath;

  Future<Uint8List> _loadBytes() {
    return XFile(imagePath).readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _loadBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Cargando imagen...'),
              ],
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('No se pudo cargar la imagen adjunta.');
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Image.memory(
            snapshot.data!,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}