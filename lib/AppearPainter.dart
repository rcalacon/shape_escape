import 'package:flutter/material.dart';

class AppearPainter extends CustomPainter {
  final double opacity;
  final Rect rect;
  AppearPainter(this.rect, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color.fromRGBO(0,0,0, opacity);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}