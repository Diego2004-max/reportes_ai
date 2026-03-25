import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/app_card.dart';

/// Map screen — shows a visual simulation of a map with markers, 
/// and a floating bottom panel showing nearby reports.
/// UI only — no real maps SDK used here to avoid API key requirements.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  // ── Mock Marker Data ──────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _mockMarkers = [
    {'x': 0.3, 'y': 0.4, 'color': AppColors.warning, 'icon': Icons.schedule_rounded},
    {'x': 0.6, 'y': 0.2, 'color': AppColors.primary, 'icon': Icons.autorenew_rounded},
    {'x': 0.4, 'y': 0.7, 'color': AppColors.success, 'icon': Icons.check_circle_rounded},
    {'x': 0.8, 'y': 0.5, 'color': AppColors.warning, 'icon': Icons.schedule_rounded},
    {'x': 0.2, 'y': 0.6, 'color': AppColors.error, 'icon': Icons.cancel_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant, // simulates a map background gray
      body: Stack(
        children: [
          // ── Simulated Map Area ────────────────────────────────────────────
          // A grid pattern to look like a map background
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _GridPainter(color: AppColors.textPrimary),
              ),
            ),
          ),
          
          // Render mock markers
          ..._mockMarkers.map((m) {
            return Positioned(
              left: size.width * (m['x'] as double),
              top: size.height * (m['y'] as double),
              child: _MapPin(
                color: m['color'] as Color,
                icon: m['icon'] as IconData,
              ),
            );
          }),

          // ── Floating Header ───────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.md,
            left: AppSpacing.screenH,
            right: AppSpacing.screenH,
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Mostrando reportes cercanos',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.my_location_rounded, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),

          // ── Floating Bottom Panel (Nearby Reports) ────────────────────────
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.screenH,
            right: AppSpacing.screenH,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSpacing.lg, top: AppSpacing.lg, right: AppSpacing.lg, bottom: AppSpacing.sm),
                    child: Text(
                      'Reportes cerca de ti',
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  _NearbyReportItem(
                    title: 'Fuga de agua en Calle 5',
                    distance: 'A 200m',
                    status: 'Pendiente',
                    statusColor: AppColors.warning,
                    onTap: () {},
                  ),
                  const Divider(),
                  _NearbyReportItem(
                    title: 'Bache en Avenida Principal',
                    distance: 'A 450m',
                    status: 'En Proceso',
                    statusColor: AppColors.primary,
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private sub-widgets & painters ──────────────────────────────────────────

class _MapPin extends StatelessWidget {
  const _MapPin({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(100),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.surface, width: 2),
          ),
          child: Icon(icon, color: AppColors.textOnPrimary, size: 20),
        ),
        // Pin pointer
        CustomPaint(
          size: const Size(12, 8),
          painter: _TrianglePainter(color: color),
        ),
      ],
    );
  }
}

class _NearbyReportItem extends StatelessWidget {
  const _NearbyReportItem({
    required this.title,
    required this.distance,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  final String title;
  final String distance;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    distance,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    
    const double step = 50.0;
    
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
