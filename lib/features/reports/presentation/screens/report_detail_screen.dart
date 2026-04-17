import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/primary_button.dart';

/// Report Detail screen — shows full report info in structured card sections.
/// UI only — edit/delete/navigate actions have TODO placeholders.
class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key, this.reportId});

  /// Identifier passed from the list screen (wired by navigation controller).
  final String? reportId;

  // ── Mock data ─────────────────────────────────────────────────────────────
  static const _mockTitle       = 'Bache en Avenida Principal';
  static const _mockDescription =
      'Se detectó un bache de aproximadamente 50 cm de diámetro y 15 cm de '
      'profundidad en la Avenida Principal entre calles 3 y 4. Afecta la '
      'circulación vehicular y representa un riesgo para motociclistas. '
      'Se requiere intervención de la Secretaría de Infraestructura.';
  static const _mockStatus      = 'En Proceso';
  static const _mockDate        = '24 de marzo de 2026';
  static const _mockCategory    = 'Infraestructura Vial';
  static const _mockLocation    = 'Av. Principal entre Calles 3 y 4, Pasto';
  static const _mockReporter    = 'Juan Pérez';
  static const _mockPriority    = 'Alta';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _mockStatus.statusColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Detalle del Reporte',
        showBack: true,
        actions: [
          // Edit action
          IconButton(
            onPressed: () {
              // TODO: navigate to edit screen
            },
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            tooltip: 'Editar',
          ),
          // Delete action
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 18,
              ),
            ),
            tooltip: 'Eliminar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH, vertical: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Status + title header ──────────────────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: _mockStatus.statusBackground,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_mockStatus.statusIcon,
                                size: 14, color: statusColor),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              _mockStatus,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _PriorityBadge(priority: _mockPriority),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(_mockTitle, style: theme.textTheme.titleLarge),

                  const SizedBox(height: AppSpacing.sm),

                  // Meta row
                  Wrap(
                    spacing: AppSpacing.lg,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _MetaChip(
                          icon: Icons.category_outlined,
                          label: _mockCategory),
                      _MetaChip(
                          icon: Icons.calendar_today_outlined,
                          label: _mockDate),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Description ───────────────────────────────────────────────
            _SectionLabel('Descripción'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Text(
                _mockDescription,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Location ──────────────────────────────────────────────────
            _SectionLabel('Ubicación'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: const Icon(Icons.location_on_rounded,
                        color: AppColors.success, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dirección',
                            style: theme.textTheme.labelMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(_mockLocation,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: navigate to map with location
                    },
                    icon: const Icon(Icons.open_in_new_rounded,
                        size: 18, color: AppColors.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Reporter info ─────────────────────────────────────────────
            _SectionLabel('Información del Reportante'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _mockReporter[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_mockReporter,
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Ciudadano',
                          style: theme.textTheme.labelMedium),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Images placeholder ────────────────────────────────────────
            _SectionLabel('Imágenes adjuntas'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) => _ImageThumbnail(
                        index: index,
                        onTap: () {
                          // TODO: open image viewer
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: add image from gallery/camera
                    },
                    icon: const Icon(Icons.add_photo_alternate_outlined,
                        size: 18),
                    label: const Text('Agregar imagen'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Action buttons ────────────────────────────────────────────
            PrimaryButton(
              label: 'Editar Reporte',
              onPressed: () {
                // TODO: navigate to edit screen
              },
              icon: const Icon(Icons.edit_outlined, size: 18,
                  color: AppColors.textOnPrimary),
            ),

            const SizedBox(height: AppSpacing.md),

            PrimaryButton(
              label: 'Eliminar Reporte',
              onPressed: () => _confirmDelete(context),
              backgroundColor: AppColors.errorLight,
              foregroundColor: AppColors.error,
              icon: const Icon(Icons.delete_outline_rounded, size: 18,
                  color: AppColors.error),
            ),

            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        title: const Text('Eliminar reporte',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este reporte? '
          'Esta acción no se puede deshacer.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style:
                TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: call delete controller, then navigate back
    }
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.8,
          ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textDisabled),
        const SizedBox(width: 4),
        Text(label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                )),
      ],
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});
  final String priority;

  Color get _color => switch (priority) {
        'Alta' => AppColors.error,
        'Media' => AppColors.warning,
        _ => AppColors.success,
      };

  Color get _bg => switch (priority) {
        'Alta' => AppColors.errorLight,
        'Media' => AppColors.warningLight,
        _ => AppColors.successLight,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        'Prioridad $priority',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({required this.index, required this.onTap});
  final int index;
  final VoidCallback onTap;

  static const List<Color> _gradients = [
    AppColors.primaryLight,
    AppColors.success,
    AppColors.warning,
    AppColors.secondary,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _gradients[index % _gradients.length];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color.withAlpha(40),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, color: color, size: 32),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Imagen ${index + 1}',
              style: TextStyle(fontSize: 11, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Extension used from report_card.dart (re-export safe) ────────────────────
extension _ReportStatusDetail on String {
  Color get statusColor {
    switch (this) {
      case 'Pendiente':    return AppColors.warning;
      case 'En Proceso':   return AppColors.primary;
      case 'Resuelto':     return AppColors.success;
      case 'Rechazado':    return AppColors.error;
      default:             return AppColors.textDisabled;
    }
  }

  Color get statusBackground {
    switch (this) {
      case 'Pendiente':    return AppColors.warningLight;
      case 'En Proceso':   return AppColors.infoLight;
      case 'Resuelto':     return AppColors.successLight;
      case 'Rechazado':    return AppColors.errorLight;
      default:             return AppColors.surfaceVariant;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case 'Pendiente':    return Icons.schedule_rounded;
      case 'En Proceso':   return Icons.autorenew_rounded;
      case 'Resuelto':     return Icons.check_circle_rounded;
      case 'Rechazado':    return Icons.cancel_rounded;
      default:             return Icons.help_outline_rounded;
    }
  }
}
