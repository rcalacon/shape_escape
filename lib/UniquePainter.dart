import 'package:flutter/material.dart';
import 'dart:math';

const PASTEL_COLOR_OPTION_ONE = Color(0xffe0bbe4);
const PASTEL_COLOR_OPTION_ONE_ALT_ONE = Color(0xffd0aad3);
const PASTEL_COLOR_OPTION_ONE_ALT_TWO = Color(0xfff1ccf5);

const PASTEL_COLOR_OPTION_TWO = Color(0xff957dad);
const PASTEL_COLOR_OPTION_TWO_ALT_ONE = Color(0xff846cac);
const PASTEL_COLOR_OPTION_TWO_ALT_TWO = Color(0xffa68ebe);

const PASTEL_COLOR_OPTION_THREE = Color(0xffd291bc);
const PASTEL_COLOR_OPTION_THREE_ALT_ONE = Color(0xffc180ab);
const PASTEL_COLOR_OPTION_THREE_ALT_TWO = Color(0xfff3a2cd);

const PASTEL_COLOR_OPTION_FOUR = Color(0xfffec8d8);
const PASTEL_COLOR_OPTION_FOUR_ALT_ONE = Color(0xffedb7c7);
const PASTEL_COLOR_OPTION_FOUR_ALT_TWO = Color(0xffffd9e9);

const PASTEL_COLOR_OPTION_FIVE = Color(0xffffccb6);
const PASTEL_COLOR_OPTION_FIVE_ALT_ONE = Color(0xffeebba5);
const PASTEL_COLOR_OPTION_FIVE_ALT_TWO = Color(0xffffddc7);

class UniquePainter extends CustomPainter {
  final List shapePositions;
  final List labelPositions;
  final int currentLevel;
  final int correctAnswer;
  final int shapeCombo;
  final int shapeColorOne;
  final int shapeColorTwo;
  final int diffColorCombo;
  final int diffSizeCombo;
  final String _fontFamily = "Satisfy";
  final double shapeRadius = 50;
  final int correctSize;
  double diffShapeRadiusOne;
  double diffShapeRadiusTwo;
  Color diffShapeColor;
  Color diffShapeColorTwo;
  Paint paintOne;
  Paint paintTwo;

  UniquePainter(this.shapePositions, this.labelPositions, this.currentLevel, this.correctAnswer, this.shapeCombo, this.shapeColorOne, this.shapeColorTwo, this.diffColorCombo, this.diffSizeCombo, this.correctSize){
    paintOne = Paint()
     ..color = getColorFromCode(shapeColorOne);

    paintTwo = Paint()
     ..color = getColorFromCode(shapeColorTwo);

    setDiffColors();

    if(diffSizeCombo == 0){
      diffShapeRadiusOne = 55;
      diffShapeRadiusTwo = 45;
    }else {
      diffShapeRadiusOne = 45;
      diffShapeRadiusTwo = 55;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    //****************************************************************************//
    //****************************Draw*Labels*************************************//
    //****************************************************************************//
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

    //****************************************************************************//
    //**********************************Levels************************************//
    //****************************************************************************//
    switch(currentLevel){
      case 1: { // different shape and color
          if(shapeCombo == 0){
            for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
              var currentShapePostion = shapePositions[shapePositionIndex];
              Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
              if((shapePositionIndex + 1) == correctAnswer){
                Rect differentShape = new Rect.fromCircle(center: offset, radius: shapeRadius);
                canvas.drawRect(differentShape, paintOne);
              }
              else{
                canvas.drawCircle(offset, shapeRadius, paintTwo);
              }
            }
          }
          else {
            for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
              var currentShapePosition = shapePositions[shapePositionIndex];
              Offset offset = new Offset(currentShapePosition[0].toDouble(), currentShapePosition[1].toDouble());
              if((shapePositionIndex + 1) == correctAnswer){
                canvas.drawCircle(offset, 50, paintOne);
              }
              else{
                Rect differentShape = new Rect.fromCircle(center: offset, radius: shapeRadius);
                canvas.drawRect(differentShape, paintTwo);
              }
            }
          }
        break;
      }
      case 2: { // different shape, make it somewhat obvious
        if(shapeCombo == 0){
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePosition = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePosition[0].toDouble(), currentShapePosition[1].toDouble());
            if((shapePositionIndex + 1) == correctAnswer){
              Rect differentShape = new Rect.fromCircle(center: offset, radius: shapeRadius);
              canvas.drawRect(differentShape, paintOne);
            }
            else{
              canvas.drawCircle(offset, shapeRadius, paintOne);
            }
          }
        }
        else {
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePostion = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawCircle(offset, shapeRadius, paintOne);
            }
            else{
              Rect differentShape = new Rect.fromCircle(center: offset, radius: shapeRadius);
              canvas.drawRect(differentShape, paintOne);
            }
          }
        }
        break;
      }
      case 3: { // different color, make it somewhat obvious
        Paint paintDiff = Paint()
          ..color = diffShapeColor;

        if(shapeCombo == 0){
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePostion = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawCircle(offset, shapeRadius, paintDiff);
            }
            else{
              canvas.drawCircle(offset, shapeRadius, paintOne);
            }
          }
        }
        else {
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePostion = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
            Rect differentShape = new Rect.fromCircle(center: offset, radius: 50);
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawRect(differentShape, paintDiff);
            }
            else{
              canvas.drawRect(differentShape, paintOne);
            }
          }
        }
        break;
      }
      case 4: { // different size, make it somewhat obvious
        if(shapeCombo == 0){
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePostion = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawCircle(offset, diffShapeRadiusOne, paintOne);
            }
            else{
              canvas.drawCircle(offset, shapeRadius, paintOne);
            }
          }
        }
        else {
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePostion = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
            Rect sameShape = new Rect.fromCircle(center: offset, radius: shapeRadius);
            Rect diffShape = new Rect.fromCircle(center: offset, radius: diffShapeRadiusOne);
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawRect(diffShape, paintOne);
            }
            else{
              canvas.drawRect(sameShape, paintOne);
            }
          }
        }
        break;
      }
      case 5: { // different color, where 2x same color and other 2x same color
        Paint paintDiff = Paint()
          ..color = diffShapeColor;
        var numColorOnePlots = 0;

        if(shapeCombo == 0){
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePostion = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePostion[0].toDouble(), currentShapePostion[1].toDouble());
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawCircle(offset, shapeRadius, paintDiff);
            }
            else{
              if(numColorOnePlots < 2) {
                canvas.drawCircle(offset, shapeRadius, paintOne);
                numColorOnePlots++;
              }else {
                canvas.drawCircle(offset, shapeRadius, paintTwo);
              }
            }
          }
        }
        else {
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePosition = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePosition[0].toDouble(), currentShapePosition[1].toDouble());
            Rect rect = new Rect.fromCircle(center: offset, radius: shapeRadius);
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawRect(rect, paintDiff);
            }
            else{
              if(numColorOnePlots < 2) {
                canvas.drawRect(rect, paintOne);
                numColorOnePlots++;
              }else {
                canvas.drawRect(rect, paintTwo);
              }
            }
          }
        }
        break;
      }
      case 6: { // different size, where 2x same size and other 2x same size
        double sameSizeOne;
        double sameSizeTwo;
        double diffSize;
        switch(correctSize){
          case 0:{
            diffSize = shapeRadius;
            sameSizeOne = diffShapeRadiusOne;
            sameSizeTwo = diffShapeRadiusTwo;
            break;
          }
          case 1:{
            diffSize = diffShapeRadiusOne;
            sameSizeOne = shapeRadius;
            sameSizeTwo = diffShapeRadiusTwo;
            break;
          }
          case 2:{
            diffSize = diffShapeRadiusTwo;
            sameSizeOne = diffShapeRadiusOne;
            sameSizeTwo = shapeRadius;
            break;
          }
        }
        var numSizeOnePlots = 0;

        if(shapeCombo == 0){
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePosition = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePosition[0].toDouble(), currentShapePosition[1].toDouble());
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawCircle(offset, diffSize, paintOne);
            }
            else{
              if(numSizeOnePlots < 2) {
                canvas.drawCircle(offset, shapeRadius, paintOne);
                numSizeOnePlots++;
              }else {
                canvas.drawCircle(offset, shapeRadius, paintOne);
              }
            }
          }
        }
        else {
          for(var shapePositionIndex = 0; shapePositionIndex < shapePositions.length; shapePositionIndex++){
            var currentShapePosition = shapePositions[shapePositionIndex];
            Offset offset = new Offset(currentShapePosition[0].toDouble(), currentShapePosition[1].toDouble());
            Rect diffRect = new Rect.fromCircle(center: offset, radius: diffSize);
            Rect sameRectOne = new Rect.fromCircle(center: offset, radius: sameSizeOne);
            Rect sameRectTwo = new Rect.fromCircle(center: offset, radius: sameSizeTwo);
            if((shapePositionIndex + 1) == correctAnswer){
              canvas.drawRect(diffRect, paintOne);
            }
            else{
              if(numSizeOnePlots < 2) {
                canvas.drawRect(sameRectOne, paintOne);
                numSizeOnePlots++;
              }else {
                canvas.drawRect(sameRectTwo, paintOne);
              }
            }
          }
        }
        break;
      }
    }
  }

  void setDiffColors(){
    switch(shapeColorOne){
      case 1: {
        if(diffColorCombo == 0) {
          diffShapeColor = PASTEL_COLOR_OPTION_ONE_ALT_ONE;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_ONE_ALT_TWO;
        }
        else {
          diffShapeColor = PASTEL_COLOR_OPTION_ONE_ALT_TWO;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_ONE_ALT_ONE;
        }
        break;
      }
      case 2: {
        if(diffColorCombo == 0) {
          diffShapeColor = PASTEL_COLOR_OPTION_TWO_ALT_ONE;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_TWO_ALT_TWO;
        }
        else {
          diffShapeColor = PASTEL_COLOR_OPTION_TWO_ALT_TWO;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_TWO_ALT_ONE;
        }
        break;
      }
      case 3: {
        if(diffColorCombo == 0) {
          diffShapeColor = PASTEL_COLOR_OPTION_THREE_ALT_ONE;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_THREE_ALT_TWO;
        }
        else {
          diffShapeColor = PASTEL_COLOR_OPTION_THREE_ALT_TWO;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_THREE_ALT_ONE;
        }
        break;
      }
      case 4: {
        if(diffColorCombo == 0) {
          diffShapeColor = PASTEL_COLOR_OPTION_FOUR_ALT_ONE;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_FOUR_ALT_TWO;
        }
        else {
          diffShapeColor = PASTEL_COLOR_OPTION_FOUR_ALT_TWO;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_FOUR_ALT_ONE;
        }
        break;
      }
      case 5: {
        if(diffColorCombo == 0) {
          diffShapeColor = PASTEL_COLOR_OPTION_FIVE_ALT_ONE;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_FIVE_ALT_TWO;
        }
        else {
          diffShapeColor = PASTEL_COLOR_OPTION_FIVE_ALT_TWO;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_FIVE_ALT_ONE;
        }
        break;
      }
      default: {
        if(diffColorCombo == 0) {
          diffShapeColor = PASTEL_COLOR_OPTION_ONE_ALT_ONE;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_ONE_ALT_TWO;
        }
        else {
          diffShapeColor = PASTEL_COLOR_OPTION_ONE_ALT_TWO;
          diffShapeColorTwo = PASTEL_COLOR_OPTION_ONE_ALT_ONE;
        }
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