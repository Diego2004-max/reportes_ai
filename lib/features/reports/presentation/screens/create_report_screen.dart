import 'package:flutter/material.dart';

import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/shared/widgets/app_card.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';

class CreateReportScreen extends StatelessWidget {
  const CreateReportScreen({super.key});

  void _showPendingFlow(BuildContext context, String flowName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$flowName será la siguiente pantalla que vamos a crear.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Crear reporte',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Cómo quieres reportar?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Elige el tipo de reporte que quieres enviar. Luego armamos cada flujo por separado para que quede más claro y profesional.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                onTap: () => _showPendingFlow(context, 'Reporte escrito'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: scheme.primary.withAlpha(18),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: scheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Reporte escrito',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Para usuarios que quieren escribir el incidente manualmente.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _FlowPoint(text: 'Título obligatorio'),
                        _FlowPoint(text: 'Categoría obligatoria'),
                        _FlowPoint(text: 'Descripción obligatoria'),
                        _FlowPoint(text: 'Ubicación obligatoria'),
                        _FlowPoint(text: 'Imagen opcional'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => _showPendingFlow(context, 'Reporte escrito'),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Continuar con reporte escrito'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                onTap: () => _showPendingFlow(context, 'Reporte por audio'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: scheme.secondary.withAlpha(18),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(
                        Icons.mic_rounded,
                        color: scheme.secondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Reporte por audio',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Para usuarios que prefieren enviar evidencia hablada y luego enriquecerla con IA.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _FlowPoint(text: 'Título obligatorio'),
                        _FlowPoint(text: 'Categoría obligatoria'),
                        _FlowPoint(text: 'Audio obligatorio'),
                        _FlowPoint(text: 'Ubicación obligatoria'),
                        _FlowPoint(text: 'Imagen opcional'),
                        _FlowPoint(text: 'Descripción opcional por ahora'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Text(
                        'Luego aquí metemos transcripción, OCR y clasificación automática.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => _showPendingFlow(context, 'Reporte por audio'),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Continuar con reporte por audio'),
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

class _FlowPoint extends StatelessWidget {
  const _FlowPoint({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}