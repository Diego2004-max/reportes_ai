import 'package:flutter/material.dart';

import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/features/reports/presentation/screens/create_audio_report_screen.dart';
import 'package:reportes_ai/features/reports/presentation/screens/create_written_report_screen.dart';
import 'package:reportes_ai/shared/widgets/app_card.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';

class CreateReportScreen extends StatelessWidget {
  const CreateReportScreen({super.key});

  void _openWritten(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateWrittenReportScreen(),
      ),
    );
  }

  void _openAudio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAudioReportScreen(),
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
                'Elige el tipo de reporte que deseas enviar.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                onTap: () => _openWritten(context),
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
                      'Ideal para quien quiere escribir manualmente el incidente.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FlowPoint(text: 'Título obligatorio'),
                    const _FlowPoint(text: 'Categoría obligatoria'),
                    const _FlowPoint(text: 'Descripción obligatoria'),
                    const _FlowPoint(text: 'Ubicación obligatoria'),
                    const _FlowPoint(text: 'Imagen opcional'),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => _openWritten(context),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Continuar con reporte escrito'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                onTap: () => _openAudio(context),
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
                      'Ideal para quien quiere enviar evidencia hablada.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FlowPoint(text: 'Título obligatorio'),
                    const _FlowPoint(text: 'Categoría obligatoria'),
                    const _FlowPoint(text: 'Audio obligatorio'),
                    const _FlowPoint(text: 'Ubicación obligatoria'),
                    const _FlowPoint(text: 'Imagen opcional'),
                    const _FlowPoint(text: 'Descripción opcional'),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => _openAudio(context),
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
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}