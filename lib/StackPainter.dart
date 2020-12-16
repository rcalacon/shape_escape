import 'package:flutter/material.dart';

class StackPainter extends CustomPainter {
  final double xPosition;
  final double rectWidth;
  final double rectBottom;
  final Color rectColor;
  final List stacks;
  final List stackColors;
  final double rectHeight;
  StackPainter(this.rectWidth, this.xPosition, this.rectBottom, this.rectColor, this.stacks, this.stackColors, this.rectHeight);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = rectColor;

    for(int stackIndex = 0; stackIndex < stacks.length; stackIndex++){
      Rect currentStack = stacks[stackIndex];
      canvas.drawRect(currentStack, Paint()..color = this.stackColors[stackIndex]);
    }

    //canvas.drawRect(rect, paint);
    double left = xPosition - (rectWidth/2);
    double right = xPosition + (rectWidth/2);
    double bottom = rectBottom;
    double top = rectBottom - rectHeight;
    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}