import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class ArcLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final bool showTagline;
  final double progress; // 0.0 to 1.0 for arc drawing animation

  const ArcLogo({
    super.key,
    this.size = 120,
    this.showWordmark = true,
    this.showTagline = false,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size * 0.9),
          painter: _ArcRingPainter(progress: progress),
        ),
        if (showWordmark) ...[
          const SizedBox(height: 12),
          Text(
            'ARC',
            style: AppTypography.brandWordmark.copyWith(
              fontSize: size * 0.28,
              letterSpacing: 8.0,
            ),
          ),
        ],
        if (showTagline) ...[
          const SizedBox(height: 14),
          Text(
            'START YOUR ARC.',
            style: AppTypography.brandTagline,
          ),
        ],
      ],
    );
  }
}

class _ArcRingPainter extends CustomPainter {
  final double progress;

  _ArcRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // Glowing halo behind the ring
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(
        colors: [
          AppColors.borderGoldGlow.withOpacity(0.4 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 20));

    // Open arc at the bottom (sweep from approx 50 degrees to 310 degrees)
    const startAngle = 0.8 * math.pi; // ~144 deg
    final totalSweep = 1.4 * math.pi; // ~252 deg
    final sweepAngle = totalSweep * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    // The golden primary arc
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [
          AppColors.goldDark,
          AppColors.goldLight,
          AppColors.gold,
          AppColors.goldLight,
        ],
        stops: [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      ringPaint,
    );

    // Corona flare at top
    if (progress > 0.5) {
      final flarePaint = Paint()
        ..color = AppColors.goldLight.withOpacity(0.8 * ((progress - 0.5) * 2))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(
        Offset(center.dx + radius * math.cos(startAngle + sweepAngle / 2),
            center.dy + radius * math.sin(startAngle + sweepAngle / 2)),
        4,
        flarePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArcRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
