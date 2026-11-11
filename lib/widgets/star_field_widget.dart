import 'dart:math';
import 'package:flutter/material.dart';
import '../painters/star_field_painter.dart';

class StarFieldWidget extends StatefulWidget {
  const StarFieldWidget({super.key});

  @override
  State<StarFieldWidget> createState() => _StarFieldWidgetState();
}

class _StarFieldWidgetState extends State<StarFieldWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();
    _stars = _generateStars(200);
  }

  List<Star> _generateStars(int count) {
    return List.generate(count, (_) {
      return Star(
        x: _random.nextDouble() * 2000,
        y: _random.nextDouble() * 2000,
        radius: _random.nextDouble() * 2 + 0.5,
        opacity: _random.nextDouble() * 0.7 + 0.3,
        speed: _random.nextDouble() * 3 + 1,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: StarFieldPainter(
            stars: _stars,
            animation: _controller.value * 2 * pi * 10,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}
