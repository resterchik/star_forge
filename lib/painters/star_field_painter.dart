import 'dart:math';
import 'package:flutter/material.dart';

class Star {
  double x;
  double y;
  double radius;
  double opacity;
  double speed;

  Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.speed,
  });
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final double animation;

  StarFieldPainter({required this.stars, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle = (sin(animation * star.speed + star.x) + 1) / 2;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: star.opacity * (0.5 + twinkle * 0.5))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.radius * 0.5);

      canvas.drawCircle(
        Offset(star.x % size.width, star.y % size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) => true;
}
