import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/core/services/location_service.dart';
import 'package:reportes_ai/core/services/speech_service.dart';
import 'package:reportes_ai/core/services/voice_service.dart';
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

  final LocationService _locationService = LocationService();
  final VoiceService _voiceService = VoiceService();
  final SpeechService _speechService = SpeechService();

  bool _isLoading = false;
  bool _isGettingLocation = false;
  bool _isRecording = false;
  bool _isListening = false;

  String _selectedCategory = 'Infraestructura';

  Position? _currentPosition;
  String? _locationLabel;
  String? _audioPath;

  final List<String> _categories = const [
    'Infraestructura',
    'Accidente de tránsito',
    'Seguridad',
    'Emergencia climática',
    'Servicios públicos',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      final position = await _locationService.getCurrentLocation();
      final address = await _locationService.getReadableAddress(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _locationLabel = address ??
            'Lat ${position.latitude.toStringAsFixed(5)}, Lng ${position.longitude.toStringAsFixed(5)}';
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo obtener ubicación: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  String _buildTitleFromDescription(String text) {
    final clean = text.trim().replaceAll('\n', ' ');
    if (clean.isEmpty) return '';

    final words = clean.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final short = words.take(5).join(' ');

    if (short.isEmpty) return '';
    return short[0].toUpperCase() + short.substring(1);
  }

  Future<void> _toggleVoiceDictation() async {
    try {
      if (_isListening) {
        await _speechService.stopListening();

        if (!mounted) return;
        setState(() => _isListening = false);

        return;
      }

      await _speechService.startListening(
        onResult: (text, isFinal) {
          if (!mounted) return;

          setState(() {
            _descriptionController.text = text;
            _descriptionController.selection = TextSelection.fromPosition(
              TextPosition(offset: _descriptionController.text.length),
            );

            if (_titleController.text.trim().isEmpty && text.trim().isNotEmpty) {
              _titleController.text = _buildTitleFromDescription(text);
              _titleController.selection = TextSelection.fromPosition(
                TextPosition(offset: _titleController.text.length),
              );
            }

            if (isFinal) {
              _isListening = false;
            }
          });
        },
      );

      if (!mounted) return;
      setState(() => _isListening = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Habla ahora. Tu voz se convertirá en texto.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isListening = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo iniciar el dictado: $e')),
      );
    }
  }

  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        final path = await _voiceService.stopRecording();

        if (!mounted) return;

        setState(() {
          _isRecording = false;
          _audioPath = path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio grabado correctamente')),
        );
      } else {
        await _voiceService.startRecording();

        if (!mounted) return;

        setState(() {
          _isRecording = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grabación iniciada')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isRecording = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo grabar audio: $e')),
      );
    }
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
            locationLabel: _locationLabel,
            latitude: _currentPosition?.latitude,
            longitude: _currentPosition?.longitude,
            audioPath: _audioPath,
          );

      ref.invalidate(userReportsProvider);
      ref.invalidate(userReportStatsProvider);
      ref.invalidate(allReportsProvider);

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
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  'Puedes dictar el reporte con tu voz o escribirlo manualmente.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dictado por voz',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _isListening
                            ? 'Escuchando... habla ahora'
                            : 'Toca el botón y dicta tu reporte. La descripción se llenará automáticamente.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          FilledButton.icon(
                            onPressed: _toggleVoiceDictation,
                            icon: Icon(
                              _isListening
                                  ? Icons.stop_circle_outlined
                                  : Icons.keyboard_voice_rounded,
                            ),
                            label: Text(
                              _isListening
                                  ? 'Detener dictado'
                                  : 'Dictar reporte',
                            ),
                          ),
                          if (_descriptionController.text.trim().isNotEmpty)
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _descriptionController.clear();
                                  if (_titleController.text ==
                                      _buildTitleFromDescription(
                                        _descriptionController.text,
                                      )) {
                                    _titleController.clear();
                                  }
                                });
                              },
                              icon: const Icon(Icons.clear_rounded),
                              label: const Text('Limpiar dictado'),
                            ),
                        ],
                      ),
                    ],
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
                    color: theme.cardTheme.color ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor),
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

                const SizedBox(height: AppSpacing.lg),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ubicación del reporte',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (_isGettingLocation)
                        const Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text('Obteniendo ubicación actual...'),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _locationLabel ?? 'Sin ubicación capturada',
                              style: theme.textTheme.bodyMedium,
                            ),
                            if (_currentPosition != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Lat ${_currentPosition!.latitude.toStringAsFixed(5)}, Lng ${_currentPosition!.longitude.toStringAsFixed(5)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed:
                            _isGettingLocation ? null : _loadCurrentLocation,
                        icon: const Icon(Icons.my_location_rounded),
                        label: const Text('Actualizar ubicación'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audio del reporte',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _audioPath == null
                            ? 'Graba un audio como evidencia opcional'
                            : 'Audio adjunto correctamente',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton.icon(
                        onPressed: _toggleRecording,
                        icon: Icon(
                          _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        ),
                        label: Text(
                          _isRecording
                              ? 'Detener grabación'
                              : 'Grabar audio',
                        ),
                      ),
                    ],
                  ),
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