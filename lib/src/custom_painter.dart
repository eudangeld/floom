import 'package:floom/src/fire_colors.dart';
import 'package:flutter/material.dart';

class FloomPainter extends CustomPainter {
  final List<int> fire;
  final int fireWidth;
  final int fireHeight;
  final double scale = 4.0;

  FloomPainter(this.fire, this.fireWidth, this.fireHeight);

  @override
  void paint(Canvas canvas, Size size) {
    for (int row = 0; row < fireHeight; row++) {
      for (int column = 0; column < fireWidth; column++) {
        final pixelIndex = column + (fireWidth * row);
        final fireIntensity = fire[pixelIndex];
        final color = FIRE_COLORS[fireIntensity];

        final rect = Rect.fromLTWH(column * scale, row * scale, scale, scale);
        final paint = Paint()..color = color;

        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
