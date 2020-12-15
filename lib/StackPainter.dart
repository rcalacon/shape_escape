import 'package:flutter/material.dart';

class StackPainter extends CustomPainter {
  final double xPosition;
  final Rect rect;
  StackPainter(this.rect, this.xPosition);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color.fromRGBO(0,0,0, 1);

    //canvas.drawRect(rect, paint);
    canvas.drawRect(Rect.fromLTRB(xPosition - 50,200,(xPosition + 50),300), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}