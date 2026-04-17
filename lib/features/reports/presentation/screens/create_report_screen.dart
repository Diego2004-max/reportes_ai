import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/shared/widgets/custom_textfield.dart';
import 'package:reportes_ai/shared/widgets/primary_button.dart';
import 'package:reportes_ai/state/report_provider.dart';
import 'package:reportes_ai/state/session_provider.dart';

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key});

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  String _selectedCategory = 'Infraestructura';

  final List<String> _categories = const [
    'Infraestructura',
    'Accidente de tránsito',
    'Seguridad',
    'Emergencia climática',
    'Servicios públicos',
    'Otro',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final session = ref.read(sessionProvider);
    final userId = session.userId;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(reportRepositoryProvider).createReport(
            userId: userId,
            title: _titleController.text,
            description: _descriptionController.text,
            category: _selectedCategory,
          );

      ref.invalidate(userReportsProvider);
      ref.invalidate(userReportStatsProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado correctamente')),
      );

      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crear reporte'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nuevo incidente',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Registra un reporte ciudadano real. El sistema lo guardará en tu historial.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                CustomTextField(
                  label: 'Título',
                  controller: _titleController,
                  hint: 'Ej: Hueco grande en la avenida',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Categoría', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedCategory = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  label: 'Descripción',
                  controller: _descriptionController,
                  hint: 'Describe lo ocurrido...',
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Describe el incidente';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Enviar reporte',
                  onPressed: _submitReport,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}