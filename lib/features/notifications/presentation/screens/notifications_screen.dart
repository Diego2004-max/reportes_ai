import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/shared/widgets/notif_tile.dart';
import 'package:reportes_ai/shared/widgets/vial_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withAlpha(200),
            border: Border(
              bottom: BorderSide(color: AppColors.surfaceContainerHighest),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Marcar todo',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Section: Status updates ──────────────────────────────────
              _SectionHeader(
                title: 'Actualizaciones de reportes',
                badge: '3',
              ),
              const SizedBox(height: 12),
              NotifTile(
                title: 'Reporte atendido',
                message:
                    'Tu reporte "Hueco en la Cra 7" ha sido marcado como atendido por las autoridades.',
                date: 'Hace 5 min',
                status: 'Atendido',
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.success,
              ),
              const SizedBox(height: 10),
              NotifTile(
                title: 'Reporte en revisión',
                message:
                    'Las autoridades están revisando tu reporte "Semáforo dañado Av. 30". Te notificaremos cuando haya novedades.',
                date: 'Hace 2 horas',
                status: 'En revisión',
                icon: Icons.search_rounded,
                iconColor: AppColors.warning,
              ),
              const SizedBox(height: 10),
              NotifTile(
                title: 'Nuevo reporte cerca de ti',
                message:
                    'Se reportó un accidente a 200 m de tu ubicación habitual en la Autopista Norte.',
                date: 'Hace 3 horas',
                icon: Icons.location_on_rounded,
                iconColor: AppColors.info,
                isRead: true,
              ),
              const SizedBox(height: 10),
              NotifTile(
                title: 'Reporte rechazado',
                message:
                    'Tu reporte "Derrumbe vía al mar" fue revisado pero no se pudo verificar. Puedes enviar uno nuevo con más evidencia.',
                date: 'Ayer, 4:30 PM',
                status: 'Rechazado',
                icon: Icons.cancel_rounded,
                iconColor: AppColors.error,
                isRead: true,
              ),

              const SizedBox(height: 32),

              // ── Section: AI Alerts ───────────────────────────────────────
              const _SectionHeader(title: 'Alertas IA'),
              const SizedBox(height: 4),
              const Text(
                'Predicciones basadas en datos históricos',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Risk Summary Card
              VialCard(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.warning.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RIESGO EN TU ZONA',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Moderado',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.warning.withAlpha(25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warning_rounded,
                                color: AppColors.warning,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Probabilidad de congestión alta en vías principales hacia el norte. Sugerimos rutas alternas por la Av. Boyacá.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.update_rounded,
                                size: 14, color: AppColors.textSecondary),
                            SizedBox(width: 6),
                            Text(
                              'Actualizado hace 2 min',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Próximas horas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),

              _PredictionCard(
                title: 'Autopista Norte',
                riskLevel: 'Riesgo Alto',
                riskColor: AppColors.error,
                icon: Icons.car_crash_rounded,
                schedule: 'Hoy 5PM – 8PM',
                certainty: '94% certeza',
              ),
              const SizedBox(height: 12),
              _PredictionCard(
                title: 'Av. El Dorado',
                riskLevel: 'Tráfico Lento',
                riskColor: AppColors.warning,
                icon: Icons.traffic_rounded,
                schedule: 'Hoy 6PM – 7PM',
                certainty: '88% certeza',
              ),
              const SizedBox(height: 12),
              _PredictionCard(
                title: 'Av. Circunvalar',
                riskLevel: 'Despejado',
                riskColor: AppColors.success,
                icon: Icons.check_circle_rounded,
                schedule: 'Hoy 5PM – 8PM',
                certainty: '96% certeza',
              ),

              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 14, color: AppColors.outline),
                  SizedBox(width: 6),
                  Text(
                    'Predicciones de IA · No reemplazan a autoridades',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.outline),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.badge});

  final String title;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({
    required this.title,
    required this.riskLevel,
    required this.riskColor,
    required this.icon,
    required this.schedule,
    required this.certainty,
  });

  final String title;
  final String riskLevel;
  final Color riskColor;
  final IconData icon;
  final String schedule;
  final String certainty;

  @override
  Widget build(BuildContext context) {
    return VialCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: riskColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: riskColor.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: riskColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: riskColor.withAlpha(25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    riskLevel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: riskColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    size: 13,
                                    color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  schedule,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withAlpha(15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 13,
                                      color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    certainty,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
