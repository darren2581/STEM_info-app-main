import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpacing;

  DottedLinePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.dashSpacing = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double width = size.width;
    final double height = size.height;

    double startX = 0;
    double startY = height / 2;
    double endX = startX + dashLength;
    double endY = startY;

    while (startX < width) {
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      startX = endX + dashSpacing;
      endX = startX + dashLength;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}