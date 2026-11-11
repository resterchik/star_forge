import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_state.dart';
import '../painters/planet_painter.dart';
import '../painters/particle_painter.dart';

class PlanetWidget extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onTap;

  const PlanetWidget({
    super.key,
    required this.gameState,
    required this.onTap,
  });

  @override
  State<PlanetWidget> createState() => _PlanetWidgetState();
}

class _PlanetWidgetState extends State<PlanetWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _tapController;
  late Animation<double> _tapAnimation;

  final List<Particle> _particles = [];
  final Random _random = Random();
  DateTime _lastFrame = DateTime.now();

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _tapAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );

    // Particle update loop
    _rotationController.addListener(_updateParticles);
  }

  void _updateParticles() {
    final now = DateTime.now();
    final dt = now.difference(_lastFrame).inMilliseconds / 1000.0;
    _lastFrame = now;

    for (final p in _particles) {
      p.update(dt);
    }
    _particles.removeWhere((p) => p.isDead);
  }

  void _spawnParticles(Offset position) {
    final body = widget.gameState.currentBody;
    for (int i = 0; i < 15; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 200 + 100;
      _particles.add(Particle(
        x: position.dx,
        y: position.dy,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed - 50,
        radius: _random.nextDouble() * 4 + 2,
        color: body.colors[_random.nextInt(body.colors.length)],
        maxLife: _random.nextDouble() * 0.8 + 0.3,
      ));
    }
    // Add some golden sparkles
    for (int i = 0; i < 5; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 150 + 50;
      _particles.add(Particle(
        x: position.dx,
        y: position.dy,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed - 80,
        radius: _random.nextDouble() * 3 + 1,
        color: const Color(0xFFFFD700),
        maxLife: _random.nextDouble() * 0.6 + 0.2,
      ));
    }
  }

  void _handleTap(TapDownDetails details) {
    HapticFeedback.lightImpact();
    _tapController.forward().then((_) => _tapController.reverse());
    _spawnParticles(details.localPosition);
    widget.onTap();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: GestureDetector(
        onTapDown: _handleTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseController, _tapController]),
          builder: (context, _) {
            final body = widget.gameState.currentBody;
            return Stack(
              children: [
                // Particles layer
                CustomPaint(
                  painter: ParticlePainter(particles: _particles),
                  size: const Size(300, 300),
                ),
                // Planet layer
                Center(
                  child: Transform.scale(
                    scale: _tapAnimation.value,
                    child: CustomPaint(
                      painter: PlanetPainter(
                        colors: body.colors,
                        animation: _rotationController.value * 2 * pi,
                        pulseAnimation: _pulseController.value,
                        size: body.size,
                      ),
                      size: Size(body.size + 60, body.size + 60),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
