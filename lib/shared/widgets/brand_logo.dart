import 'package:flutter/material.dart';
import 'package:reportes_ai/app/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 68});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(size * 0.333),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.52, size * 0.52),
          painter: _BarChartPainter(),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width / 34;
    final h = size.height / 34;
    final paint = Paint()..style = PaintingStyle.fill;

    // Left bar
    paint.color = Colors.white.withOpacity(0.85);
    canvas.drawRRect(
      RRect.fromLTRBR(2 * w, 18 * h, 9 * w, 32 * h, const Radius.circular(2)),
      paint,
    );

    // Center bar (tallest)
    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromLTRBR(13.5 * w, 10 * h, 20.5 * w, 32 * h, const Radius.circular(2)),
      paint,
    );

    // Right bar
    paint.color = Colors.white.withOpacity(0.85);
    canvas.drawRRect(
      RRect.fromLTRBR(25 * w, 2 * h, 32 * w, 32 * h, const Radius.circular(2)),
      paint,
    );

    // Green accent dot (top-right of right bar)
    paint.color = AppColors.primaryLight;
    canvas.drawCircle(Offset(29 * w, 3 * h), 3.5 * w, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
