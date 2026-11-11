import 'package:flutter/material.dart';

class FloatingText extends StatefulWidget {
  final String text;
  final Offset startPosition;
  final VoidCallback onComplete;

  const FloatingText({
    super.key,
    required this.text,
    required this.startPosition,
    required this.onComplete,
  });

  @override
  State<FloatingText> createState() => _FloatingTextState();
}

class _FloatingTextState extends State<FloatingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetY;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetY = Tween<double>(begin: 0, end: -60).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );

    _controller.forward().then((_) => widget.onComplete());
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
        return Positioned(
          left: widget.startPosition.dx - 30,
          top: widget.startPosition.dy + _offsetY.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Color(0xFFFFD700),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
