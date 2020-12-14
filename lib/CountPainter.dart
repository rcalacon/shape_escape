import 'package:flutter/material.dart';

const PASTEL_COLOR_OPTION_ONE = Color(0xffe0bbe4);
const PASTEL_COLOR_OPTION_TWO = Color(0xff957dad);
const PASTEL_COLOR_OPTION_THREE = Color(0xffd291bc);
const PASTEL_COLOR_OPTION_FOUR = Color(0xfffec8d8);
const PASTEL_COLOR_OPTION_FIVE = Color(0xffffccb6);

class CountPainter extends CustomPainter {
  final List shapePositions;
  final List colorPositions;
  final List shapeTypes;
  final double shapeRadius;

  CountPainter(this.shapePositions, this.colorPositions, this.shapeRadius, this.shapeTypes);

  @override
  void paint(Canvas canvas, Size size) {
    //****************************************************************************//
    //****************************Draw*Labels*************************************//
    //****************************************************************************//
    for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
      var currentShapePostion = shapePositions[shapePositionIndex];
      Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
      if(shapeTypes[shapePositionIndex] == 0)
        canvas.drawCircle(offset, shapeRadius, Paint()..color=getColorFromCode(colorPositions[shapePositionIndex]));
      else{
        Rect rect = new Rect.fromCircle(center: offset, radius: shapeRadius);
        canvas.drawRect(rect, Paint()..color=getColorFromCode(colorPositions[shapePositionIndex]));
      }
    }
  }

  Color getColorFromCode(int code){
    switch(code){
      case 0:
        return PASTEL_COLOR_OPTION_ONE;
        break;
      case 1:
        return PASTEL_COLOR_OPTION_TWO;
        break;
      case 2:
        return PASTEL_COLOR_OPTION_THREE;
        break;
      case 3:
        return PASTEL_COLOR_OPTION_FOUR;
        break;
      case 4:
        return PASTEL_COLOR_OPTION_FIVE;
        break;
      default: return PASTEL_COLOR_OPTION_ONE;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}