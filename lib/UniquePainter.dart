import 'package:flutter/material.dart';
import 'dart:math';

const PASTEL_COLOR_OPTION_ONE = Color(0xffe0bbe4);
const PASTEL_COLOR_OPTION_TWO = Color(0xff957dad);
const PASTEL_COLOR_OPTION_THREE = Color(0xffd291bc);
const PASTEL_COLOR_OPTION_FOUR = Color(0xfffec8d8);
const PASTEL_COLOR_OPTION_FIVE = Color(0xffffccb6);

class UniquePainter extends CustomPainter {
  final List shapePositions;
  final List labelPositions;
  final int currentLevel;
  final int correctAnswer;
  final int shapeCombo;
  final int shapeColorOne;
  final int shapeColorTwo;
  final String _fontFamily = "Satisfy";
  UniquePainter(this.shapePositions, this.labelPositions, this.currentLevel, this.correctAnswer, this.shapeCombo, this.shapeColorOne, this.shapeColorTwo);

  @override
  void paint(Canvas canvas, Size size) {
    for(var labelPositionIndex = 0; labelPositionIndex < shapePositions.length; labelPositionIndex++){
      var currentShapePostion = labelPositions[labelPositionIndex];
      TextSpan span = new TextSpan(
          text: (labelPositionIndex + 1).toString(),
          style: TextStyle(
              fontSize: 25,
              fontFamily: _fontFamily,
              color: Colors.black
          )
      );
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, new Offset(currentShapePostion[0], currentShapePostion[1]));
    }

    switch(currentLevel){
      case 1: {
          Paint levelOnePaintOne = Paint()
          ..color = getColorFromCode(shapeColorOne);

          Paint levelOnePaintTwo = Paint()
          ..color = getColorFromCode(shapeColorTwo);

          //randomize shapes (either rect or circle)
          if(shapeCombo == 0){
            for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
              var currentShapePostion = shapePositions[shapePositionIndex];
              Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
              if((shapePositionIndex + 1) == correctAnswer){
                Rect differentShape = new Rect.fromCircle(center: offset, radius: 50);
                canvas.drawRect(differentShape, levelOnePaintOne);
              }
              else{
                canvas.drawCircle(offset, 50, levelOnePaintTwo);
              }
            }
          }
          else {
            for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
              var currentShapePostion = shapePositions[shapePositionIndex];
              Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
              if((shapePositionIndex + 1) == correctAnswer){
                canvas.drawCircle(offset, 50, levelOnePaintOne);
              }
              else{
                Rect differentShape = new Rect.fromCircle(center: offset, radius: 50);
                canvas.drawRect(differentShape, levelOnePaintTwo);
              }
            }
          }
        break;
      }
      case 2: {
        levelTwo(canvas);
        break;
      }
      case 3: {
        levelThree(canvas);
        break;
      }
      case 4: {
        levelFour(canvas);
        break;
      }
      case 5: {
        levelFive(canvas);
        break;
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

  void levelTwo(canvas){ // different color, make it somewhat obvious

  }

  void levelThree(canvas){ // different size, make it somewhat obvious

  }

  void levelFour(canvas){ // different color, where 2x same color and other 2x same color

  }

  void levelFive(canvas){ // different size, where 2x same size and other 2x same size

  }

  void updateDifficulty(canvas){

  }
}