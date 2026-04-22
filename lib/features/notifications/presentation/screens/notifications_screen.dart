import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/shared/widgets/shared_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: AppColors.text),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notificaciones',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Leer todo',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  children: [
                    Text(
                      'HOY',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: AppColors.faint,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const NotifTile(
                      title: 'Reporte atendido',
                      message: 'Tu reporte "Hueco en la Cra 7" ha sido marcado como atendido por las autoridades.',
                      date: 'Hace 5 min',
                      status: ReportStatus.atendido,
                    ),
                    const NotifTile(
                      title: 'Reporte en revisión',
                      message: 'Las autoridades están revisando tu reporte "Semáforo dañado Av. 30". Te notificaremos cuando haya novedades.',
                      date: 'Hace 2 horas',
                      status: ReportStatus.enRevision,
                    ),
                    const NotifTile(
                      title: 'Nuevo reporte cercano',
                      message: 'Se reportó un accidente a 200 m de tu ubicación habitual en la Autopista Norte.',
                      date: 'Hace 3 horas',
                      lineColor: AppColors.accent,
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 20),
                    Text(
                      'AYER',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: AppColors.faint,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const NotifTile(
                      title: 'Reporte rechazado',
                      message: 'Tu reporte "Derrumbe vía al mar" fue revisado pero no se pudo verificar. Puedes enviar uno nuevo con más evidencia.',
                      date: 'Ayer, 4:30 PM',
                      status: ReportStatus.rechazado,
                    ),
                    const SizedBox(height: 20),
                    AppCard(
                      radius: 24,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RIESGO EN TU ZONA',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: AppColors.faint,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Moderado',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Probabilidad de congestión alta en vías principales hacia el norte. Sugerimos rutas alternas por la Av. Boyacá.',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.muted,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.update_rounded, size: 12, color: AppColors.faint),
                              const SizedBox(width: 5),
                              Text(
                                'Actualizado hace 2 min',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.faint,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _PredictionTile(
                      title: 'Autopista Norte',
                      level: 'Riesgo alto',
                      levelColor: AppColors.error,
                      schedule: 'Hoy 5PM – 8PM',
                      certainty: '94% certeza',
                    ),
                    const SizedBox(height: 10),
                    _PredictionTile(
                      title: 'Av. El Dorado',
                      level: 'Tráfico lento',
                      levelColor: AppColors.warning,
                      schedule: 'Hoy 6PM – 7PM',
                      certainty: '88% certeza',
                    ),
                    const SizedBox(height: 10),
                    _PredictionTile(
                      title: 'Av. Circunvalar',
                      level: 'Despejado',
                      levelColor: AppColors.success,
                      schedule: 'Hoy 5PM – 8PM',
                      certainty: '96% certeza',
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 12, color: AppColors.faint),
                        const SizedBox(width: 5),
                        Text(
                          'Predicciones de IA · No reemplazan a autoridades',
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: AppColors.faint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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

class _PredictionTile extends StatelessWidget {
  final String title;
  final String level;
  final Color levelColor;
  final String schedule;
  final String certainty;

  const _PredictionTile({
    required this.title,
    required this.level,
    required this.levelColor,
    required this.schedule,
    required this.certainty,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 22,
      padding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: levelColor, borderRadius: AppRadius.borderFull),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.text,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: levelColor.withOpacity(0.1),
                        borderRadius: AppRadius.borderFull,
                      ),
                      child: Text(
                        level,
                        style: GoogleFonts.dmSans(
                          fontSize: 10, fontWeight: FontWeight.w400, color: levelColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  schedule,
                  style: GoogleFonts.dmSans(
                    fontSize: 11, fontWeight: FontWeight.w300, color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  certainty,
                  style: GoogleFonts.dmSans(
                    fontSize: 10, fontWeight: FontWeight.w300,
                    color: AppColors.accent, letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
