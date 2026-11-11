import 'dart:math';
import 'package:flutter/material.dart';

class PlanetPainter extends CustomPainter {
  final List<Color> colors;
  final double animation;
  final double pulseAnimation;
  final double size;

  PlanetPainter({
    required this.colors,
    required this.animation,
    required this.pulseAnimation,
    this.size = 120,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = size / 2;

    // Outer glow
    final glowRadius = radius + 20 + pulseAnimation * 10;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colors[0].withValues(alpha: 0.3 + pulseAnimation * 0.2),
          colors[0].withValues(alpha: 0.1),
          colors[0].withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
    canvas.drawCircle(center, glowRadius, glowPaint);

    // Main body
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          colors[1],
          colors[0],
          colors[2],
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    // Surface detail - bands/craters
    _drawSurfaceDetails(canvas, center, radius);

    // Highlight/shine
    final highlightCenter = Offset(center.dx - radius * 0.25, center.dy - radius * 0.25);
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: highlightCenter, radius: radius * 0.5));
    canvas.drawCircle(highlightCenter, radius * 0.5, highlightPaint);

    // Atmosphere ring
    final atmosPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = SweepGradient(
        colors: [
          colors[0].withValues(alpha: 0.0),
          colors[1].withValues(alpha: 0.3),
          colors[0].withValues(alpha: 0.0),
        ],
        transform: GradientRotation(animation),
      ).createShader(Rect.fromCircle(center: center, radius: radius + 5));
    canvas.drawCircle(center, radius + 5, atmosPaint);
  }

  void _drawSurfaceDetails(Canvas canvas, Offset center, double radius) {
    final random = Random(42);
    final detailPaint = Paint();

    // Draw some "craters" or "bands"
    for (int i = 0; i < 5; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final dist = random.nextDouble() * radius * 0.7;
      final craterCenter = Offset(
        center.dx + cos(angle + animation * 0.1) * dist,
        center.dy + sin(angle + animation * 0.1) * dist,
      );
      final craterRadius = radius * (0.05 + random.nextDouble() * 0.1);

      // Check if crater is within planet
      if ((craterCenter - center).distance + craterRadius < radius) {
        detailPaint
          ..color = colors[2].withValues(alpha: 0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, craterRadius * 0.3);
        canvas.drawCircle(craterCenter, craterRadius, detailPaint);
      }
    }
  }

  @override
  bool shouldRepaint(PlanetPainter oldDelegate) => true;
}
