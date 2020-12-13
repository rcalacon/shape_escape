import 'package:flutter/material.dart';

const PASTEL_COLOR_OPTION_ONE = Color(0xffe0bbe4);
const PASTEL_COLOR_OPTION_TWO = Color(0xff957dad);
const PASTEL_COLOR_OPTION_THREE = Color(0xffd291bc);
const PASTEL_COLOR_OPTION_FOUR = Color(0xfffec8d8);
const PASTEL_COLOR_OPTION_FIVE = Color(0xffffccb6);

class ReactPainter extends CustomPainter {
  final Rect rect;
  final int colorResult;
  ReactPainter(this.rect, this.colorResult);

  @override
  void paint(Canvas canvas, Size size) {
    var rectColor;
    switch(colorResult){
      case 0:
        rectColor = PASTEL_COLOR_OPTION_ONE;
        break;
      case 1:
        rectColor = PASTEL_COLOR_OPTION_TWO;
        break;
      case 2:
        rectColor = PASTEL_COLOR_OPTION_THREE;
        break;
      case 3:
        rectColor = PASTEL_COLOR_OPTION_FOUR;
        break;
      case 4:
        rectColor = PASTEL_COLOR_OPTION_FIVE;
        break;
    }

    var paint = Paint()
      ..color = rectColor;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}