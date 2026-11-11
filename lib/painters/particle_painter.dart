import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double opacity;
  double life;
  double maxLife;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
    required this.maxLife,
  })  : opacity = 1.0,
        life = 0.0;

  bool get isDead => life >= maxLife;

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    vy += 20 * dt; // slight gravity
    life += dt;
    opacity = (1 - life / maxLife).clamp(0, 1);
    radius *= 0.99;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (p.isDead) continue;
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 0.5);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
