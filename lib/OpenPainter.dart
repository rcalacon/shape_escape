import 'package:flutter/material.dart';
import 'SizeUtil.dart';

const BLUE_NORMAL = Color(0xff54c5f8);
const GREEN_NORMAL = Color(0xff6bde54);
const BLUE_DARK2 = Color(0xff01579b);
const BLUE_DARK1 = Color(0xff29b6f6);

class OpenPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width > 1.0 && size.height > 1.0) {
      print(">1.9");
      SizeUtil.size = size;
    }
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = BLUE_NORMAL
      ..isAntiAlias = true;
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void _drawFourShape(Canvas canvas,
      {Offset left_top,
        Offset right_top,
        Offset right_bottom,
        Offset left_bottom,
        Size size,
        paint}) {
    left_top = _convertLogicSize(left_top, size);
    right_top = _convertLogicSize(right_top, size);
    right_bottom = _convertLogicSize(right_bottom, size);
    left_bottom = _convertLogicSize(left_bottom, size);
    var path1 = Path()
      ..moveTo(left_top.dx, left_top.dy)
      ..lineTo(right_top.dx, right_top.dy)
      ..lineTo(right_bottom.dx, right_bottom.dy)
      ..lineTo(left_bottom.dx, left_bottom.dy);
    canvas.drawPath(path1, paint);

    var circleCenter = Offset(SizeUtil.getAxisX(294), SizeUtil.getAxisY(175));
    paint.color = BLUE_NORMAL;
    canvas.drawCircle(circleCenter, SizeUtil.getAxisBoth(174), paint);
    paint.color = GREEN_NORMAL;
    canvas.drawCircle(circleCenter, SizeUtil.getAxisBoth(124), paint);
    paint.color = Colors.white;
    canvas.drawCircle(circleCenter, SizeUtil.getAxisBoth(80), paint);

    canvas.save();
    canvas.restore();
  }
  Offset _convertLogicSize(Offset off, Size size) {
    return Offset(SizeUtil.getAxisX(off.dx), SizeUtil.getAxisY(off.dy));
  }

}