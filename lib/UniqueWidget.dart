import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'UniquePainter.dart';

class UniqueWidget extends StatefulWidget {
  UniqueWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UniqueWidgetState createState() => _UniqueWidgetState();
}

class _UniqueWidgetState extends State<UniqueWidget> with TickerProviderStateMixin {
  List _shapePositions;
  List _labelPositions;
  bool _initializedShapePositions = false;
  bool _changeLevel;
  int _correctAnswer;
  int _shapeColorOne;
  int _shapeColorTwo;
  int _diffShape;
  Animation<double> _animation;
  AnimationController _controller;
  Icon _currentLevelWidget;
  final double _appBarOffSet = 50;
  final double _utilityBarOffset = 20;
  final double _bottomBarOffset = 45;
  final double _buttonWidth = 200;
  final int _msTimeLimit = 300000; //5 minutes total
  Stopwatch _gameTimer;
  int _currentLevel;
  int _currentShapeCombo;
  bool _gameOver;
  final String _fontFamily = "Satisfy";

  @override
  void initState() {
    super.initState();

    _shapePositions = new List();
    _labelPositions = new List();

    _currentLevelWidget = Icon(Icons.looks_one);
    _changeLevel = true;

    _controller = AnimationController(
        vsync: this,
        duration : Duration(seconds : _msTimeLimit ~/ 1000)
    );

    Tween<double> _opacityTween = Tween(begin: 0, end: 1);

    _animation = _opacityTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.stop();
          _changeLevel = false;
          setState(() {
            _gameOver = true;
          });
        }
        else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();

    _gameTimer = new Stopwatch();
    _gameTimer.start();
  }

  void determineCorrectAnswer(){
    Random correctAnswerDecider = new Random();
    _correctAnswer = correctAnswerDecider.nextInt(4) + 1;
  }

  Rect createRandomPositionRect(double width, double height, int boxSize){
    Random rectPositionDecider = new Random();

    double right = rectPositionDecider.nextInt(width.toInt()).toDouble();
    if(right < boxSize) right = right + boxSize;
    double left = right - boxSize;

    double bottom = rectPositionDecider.nextInt(height.toInt()).toDouble();
    if(bottom < (boxSize + _appBarOffSet + _utilityBarOffset + _bottomBarOffset)) bottom = bottom + boxSize;
    else if(bottom > (height - _bottomBarOffset)) bottom = bottom - _bottomBarOffset;
    double top = bottom - boxSize;

    return Rect.fromLTRB(left,top,right,bottom);
  }

  int getShapeColor(){
    return new Random().nextInt(4);
  }

  int getDifferentShapeColor(otherColor){
    Random rectColorDecider = new Random();

    int colorResult = rectColorDecider.nextInt(4);
    while(colorResult == otherColor){
      colorResult = rectColorDecider.nextInt(4);
    }

    return colorResult;
  }

  _UniqueWidgetState() {
    _gameOver = false;
    _currentLevel = 1;
  }

  void initializeShapePositionsAndLabels(double screenWidth, double screenHeight){
    double yOffset = 100;
    double labelOffset = -80;

    //center
    double shapeOneX = screenWidth / 2;
    double shapeOneY = screenHeight / 2 - yOffset;

    //top left
    double shapeTwoX = shapeOneX / 2;
    double shapeTwoY = shapeOneY / 2;
    _shapePositions.add([shapeTwoX, shapeTwoY]);
    _labelPositions.add([shapeTwoX, shapeTwoY + labelOffset]);

    //top right
    double shapeThreeX = shapeOneX * 1.5;
    double shapeThreeY = shapeOneY / 2;
    _shapePositions.add([shapeThreeX, shapeThreeY]);
    _labelPositions.add([shapeThreeX, shapeThreeY + labelOffset]);

    //add center items in the middle. provides a more sensible visual.
    _shapePositions.add([shapeOneX, shapeOneY]);
    _labelPositions.add([shapeOneX, shapeOneY + labelOffset]);

    //bottom left
    double shapeFourX = shapeOneX / 2;
    double shapeFourY = shapeOneY * 1.5;
    _shapePositions.add([shapeFourX, shapeFourY]);
    _labelPositions.add([shapeFourX, shapeFourY + labelOffset]);

    //bottom right
    double shapeFiveX = shapeOneX * 1.5;
    double shapeFiveY = shapeOneY * 1.5;
    _shapePositions.add([shapeFiveX, shapeFiveY]);
    _labelPositions.add([shapeFiveX, shapeFiveY + labelOffset]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!_initializedShapePositions){
      initializeShapePositionsAndLabels(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
      _initializedShapePositions = true;
    }

    if(_changeLevel){
      _shapeColorOne = getShapeColor();
      _shapeColorTwo = getDifferentShapeColor(_shapeColorOne);
      _currentShapeCombo = new Random().nextInt(2);
      determineCorrectAnswer();
      _changeLevel = false;
    }

    return Scaffold(
      appBar: AppBar(
        leading: _currentLevelWidget,
        title: Text(
            'Unique',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 30,
            )
        ),
        actions: <Widget>[
          Text(
              " ${(_gameTimer.elapsed.inMilliseconds / 1000).toStringAsFixed(1)}",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: _fontFamily
              )
          ),
          Text(
              " Seconds",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: _fontFamily
              )
          ),
        ],
        toolbarHeight: this._appBarOffSet,
      ),
      body: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 30
                ),
                Text(
                    "Which one is Different?",
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: _fontFamily
                    )
                ),
                Expanded(
                    child: CustomPaint(
                            painter: UniquePainter(_shapePositions, _labelPositions, _currentLevel, _correctAnswer, _currentShapeCombo, _shapeColorOne, _shapeColorTwo),
                            child: Container()
                        )
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: _fontFamily
                          )
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                        )
                    ),
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: Text(
                            "2",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: _fontFamily
                            )
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                        )
                    ),
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: Text(
                            "3",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: _fontFamily
                            )
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                        )
                    ),
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: Text(
                            "4",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: _fontFamily
                            )
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                        )
                    ),
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: Text(
                            "5",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: _fontFamily
                            )
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                        )
                    ),
                  ]
                )
              ],
          )
      ),
    );
  }
}