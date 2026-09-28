import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ArcGlowHalo extends StatelessWidget {
  final double radius;
  final Offset centerOffset;

  const ArcGlowHalo({
    super.key,
    this.radius = 240,
    this.centerOffset = const Offset(0, -60),
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _HaloPainter(radius: radius, offset: centerOffset),
      ),
    );
  }
}

class _HaloPainter extends CustomPainter {
  final double radius;
  final Offset offset;

  _HaloPainter({required this.radius, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 + offset.dx, size.height * 0.15 + offset.dy);

    // Ambient diffuse glow
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32
      ..shader = RadialGradient(
        colors: [
          AppColors.goldDark.withOpacity(0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 30));

    canvas.drawCircle(center, radius, glowPaint);

    // Fine golden light crest
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = const SweepGradient(
        colors: [
          Colors.transparent,
          AppColors.gold,
          AppColors.goldLight,
          Colors.transparent,
        ],
        stops: [0.0, 0.25, 0.4, 0.7],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.6 * math.pi,
      1.2 * math.pi,
      false,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HaloPainter oldDelegate) => false;
}
