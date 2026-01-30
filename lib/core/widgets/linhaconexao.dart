import 'package:flutter/material.dart';

class ConnectionLinesPainter extends CustomPainter {
  final Color color;

  ConnectionLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 20; i++) {
      final double x = i * 60.0;
      final double y = i * 40.0;

      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(size.width, y)
        ..moveTo(0, y)
        ..lineTo(x, size.height);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
