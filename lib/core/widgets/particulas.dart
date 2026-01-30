import 'dart:math';
import 'package:flutter/material.dart';

class ParticulasWidget extends StatefulWidget {
  const ParticulasWidget({super.key});

  @override
  State<ParticulasWidget> createState() => _ParticulasWidgetState();
}

class _ParticulasWidgetState extends State<ParticulasWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = List.generate(30, (index) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
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
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = Random().nextDouble() * 3;
  double speed = Random().nextDouble() * 0.1;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    for (var p in particles) {
      final pos = Offset(
        p.x * size.width,
        ((p.y + animationValue * p.speed) % 1.0) * size.height,
      );
      canvas.drawCircle(pos, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
