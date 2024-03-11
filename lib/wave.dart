import 'package:flutter/material.dart';
import 'dart:math' as math;


class SineWavePainter extends CustomPainter {
  final double verticalOffset; // Расстояние от верха до середины волны

  SineWavePainter({this.verticalOffset = 100}); // Значение по умолчанию, если параметр не указан

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFF0ECD3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0;
    final fillPaint = Paint()
      ..color = Color(0xFFF0ECD3)
      ..style = PaintingStyle.fill;

    var path = Path();
    var fillPath = Path();
    fillPath.moveTo(0, 0);
    fillPath.lineTo(0, size.height);

    double startPhase = math.pi / 2;
    double endPhase = 2 * math.pi * 5;
    double pixelsPerRadian = size.width / endPhase;

    for (double x = 0; x <= size.width; x++) {
      double radian = x / pixelsPerRadian + startPhase;
      double y = math.sin(radian) * (size.height / 25) + verticalOffset; // Используем verticalOffset здесь

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      fillPath.lineTo(x, y);
    }

    fillPath.lineTo(size.width, 0);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class SineWaveWidget extends StatelessWidget {
  final double verticalOffset;

  SineWaveWidget({this.verticalOffset = 100}); // Значение по умолчанию

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SineWavePainter(verticalOffset: verticalOffset),
      size: Size(double.infinity, 150),
    );
  }
}