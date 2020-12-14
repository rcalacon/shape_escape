import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math';
import 'CountPainter.dart';

class CountWidget extends StatefulWidget {
  CountWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> with TickerProviderStateMixin {
  List _shapePositions;
  List _colorPositions;
  List _shapeTypes;
  bool _changeLevel;
  int _correctAnswer;
  Animation<double> _animation;
  AnimationController _controller;
  Icon _currentLevelWidget;
  final double _appBarOffSet = 50;
  final double _answerTextOffset = 30;
  final double _answerButtonsOffset = 50;
  final double _buttonWidth = 200;
  final int _msTimeLimit = 300000; //5 minutes total
  double _shapeRadius = 20;
  Stopwatch _gameTimer;
  int _currentLevel;
  final String _fontFamily = "Satisfy";

  //Canvas details fetched while debugging. Can probably improve this.
  final double canvasWidth = 411;
  final double canvasHeight = 479;

  String answerOneText;
  String answerTwoText;
  String answerThreeText;
  String answerFourText;
  String answerFiveText;

  @override
  void initState() {
    super.initState();

    _shapePositions = new List();
    _colorPositions = new List();
    _shapeTypes = new List();

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
        }
        else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();

    _gameTimer = new Stopwatch();
    _gameTimer.start();
  }

  void randomizeShapeColors(){
    for(int colorPositionIndex = 0; colorPositionIndex < _shapePositions.length; colorPositionIndex++){
      _colorPositions.add(new Random().nextInt(5));
    }
  }

  void randomizeShapeTypes(){
    for(int shapeTypeIndex = 0; shapeTypeIndex < _shapePositions.length; shapeTypeIndex++){
      _shapeTypes.add(new Random().nextInt(2));
    }
  }

  int getDifferentShapeColor(otherColor){
    Random rectColorDecider = new Random();

    int colorResult = rectColorDecider.nextInt(4);
    while(colorResult == otherColor){
      colorResult = rectColorDecider.nextInt(4);
    }

    return colorResult;
  }

  _CountWidgetState() {
    _currentLevel = 1;
  }

  List getRandomPosition(){
    Random shapePositionDecider = new Random();

    double xVal = shapePositionDecider.nextInt(canvasWidth.toInt()).toDouble();
    if(xVal < _shapeRadius) xVal = xVal + _shapeRadius;
    else if(xVal > (canvasWidth - _shapeRadius)) xVal = xVal - _shapeRadius;

    double yVal = shapePositionDecider.nextInt(canvasHeight.toInt()).toDouble();
    if(yVal < (_shapeRadius)) {
      yVal = yVal + _shapeRadius;
    }
    else if(yVal > (canvasHeight - _shapeRadius)) {
      yVal = yVal - _shapeRadius;
    }

    return [xVal, yVal];
  }

  void setShapePositions(int level){
    Random numShapesDecider = new Random();
    int variance = numShapesDecider.nextInt(4);
    int numShapesToDraw;
    switch(level){
      case 1:{
        numShapesToDraw = 5 + variance; //5 to 8
        _shapeRadius = 20;
        break;
      }
      case 2:{
        numShapesToDraw = 10 + variance; //10 to 13
        _shapeRadius = 15;
        break;
      }
      case 3:{
        numShapesToDraw = 15 + variance; //15 to 18
        _shapeRadius = 12;
        break;
      }
      case 4:{
        numShapesToDraw = 20 + variance; //20 to 23
        _shapeRadius = 10;
        break;
      }
      case 5:{
        numShapesToDraw = 25 + variance; //25 to 28
        _shapeRadius = 8;
        break;
      }
      default: {
        numShapesToDraw = 5 + variance; //5 to 8
        _shapeRadius = 20;
        break;
      }
    }
    _correctAnswer = numShapesToDraw;

    //check for drawing collision. expensive operation.
    while(_shapePositions.length < numShapesToDraw){
      List newShapePosition = getRandomPosition();

      bool validPosition = true;
      for(int comparedShapeIndex = 0; comparedShapeIndex < _shapePositions.length; comparedShapeIndex++){
        List currentShapePosition = _shapePositions[comparedShapeIndex];
        double xDiff = (currentShapePosition[0] - newShapePosition[0]);
        xDiff = xDiff.abs();
        double yDiff = currentShapePosition[1] - newShapePosition[1];
        yDiff = yDiff.abs();
        if(xDiff < _shapeRadius || yDiff < _shapeRadius) {
          validPosition = false;
        }
      }

      if(validPosition) _shapePositions.add(newShapePosition);
    }
  }

  setButtonAnswers(){
    Random answerLocationDecider = new Random();
    int answerLocation = answerLocationDecider.nextInt(5);
    switch(answerLocation){
      case 0: {
        answerOneText = _correctAnswer.toString();

        answerTwoText = (_correctAnswer + 1).toString();
        answerThreeText = (_correctAnswer + 2).toString();
        answerFourText = (_correctAnswer - 1).toString();
        answerFiveText = (_correctAnswer - 2).toString();
        break;
      }
      case 1: {
        answerTwoText = _correctAnswer.toString();

        answerOneText = (_correctAnswer + 1).toString();
        answerThreeText = (_correctAnswer + 2).toString();
        answerFourText = (_correctAnswer - 1).toString();
        answerFiveText = (_correctAnswer - 2).toString();
        break;
      }
      case 2: {
        answerThreeText = _correctAnswer.toString();

        answerOneText = (_correctAnswer + 2).toString();
        answerTwoText = (_correctAnswer + 1).toString();
        answerFourText = (_correctAnswer - 1).toString();
        answerFiveText = (_correctAnswer - 2).toString();
        break;
      }
      case 3: {
        answerFourText = _correctAnswer.toString();

        answerOneText = (_correctAnswer - 1).toString();
        answerTwoText = (_correctAnswer + 1).toString();
        answerThreeText = (_correctAnswer + 2).toString();
        answerFiveText = (_correctAnswer - 2).toString();
        break;
      }
      case 4: {
        answerFiveText = _correctAnswer.toString();

        answerOneText = (_correctAnswer - 2).toString();
        answerTwoText = (_correctAnswer + 1).toString();
        answerThreeText = (_correctAnswer + 2).toString();
        answerFourText = (_correctAnswer - 1).toString();
        break;
      }
    }
  }

  updateLevelIcon(){
    if(_currentLevel == 2){
      _currentLevelWidget = Icon(Icons.looks_two);
    }else if(_currentLevel == 3){
      _currentLevelWidget = Icon(Icons.looks_3);
    }else if(_currentLevel == 4){
      _currentLevelWidget = Icon(Icons.looks_4);
    }else if(_currentLevel == 5){
      _currentLevelWidget = Icon(Icons.looks_5);
    }else if(_currentLevel == 6){
      _currentLevelWidget = Icon(Icons.looks_6);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(this._currentLevel > 5){
      _gameTimer.stop();

      return Scaffold(
          appBar: AppBar(
            title: Text(
                'Unique',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: _fontFamily
                )
            ),
            toolbarHeight: this._appBarOffSet,
          ),
          body: Container(
            color: Colors.black87,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Results',
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          'Time Elapsed: ${_gameTimer.elapsed.inMilliseconds / 1000}s',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Image(
                        //fit: BoxFit.scaleDown,
                          height: 100,
                          image: AssetImage('assets/logo.png')
                      ),
                      Container(
                          height: 30
                      ),
                      Container(
                        width: this._buttonWidth,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              this._changeLevel = true;
                              this._gameTimer.reset();
                              this._gameTimer.start();
                              this._controller.reset();
                              this._controller.forward();
                              setState((){
                                _currentLevel = 1;
                              });
                            },
                            icon: Icon(Icons.emoji_emotions_outlined),
                            label: Text(
                              "PLAY AGAIN",
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                            )
                        ),
                      ),
                      Container(
                        width: this._buttonWidth,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back),
                            label: Text(
                              "RETURN",
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                            )
                        ),
                      ),
                    ]
                )
            ),
          )
      );
    }
    else{
      if(_changeLevel){
        updateLevelIcon();
        _shapePositions.clear();
        setShapePositions(_currentLevel);

        _colorPositions.clear();
        randomizeShapeColors();

        _shapeTypes.clear();
        randomizeShapeTypes();

        setButtonAnswers();
        _changeLevel = false;
      }

      return Scaffold(
        appBar: AppBar(
          leading: _currentLevelWidget,
          title: Text(
              'Count',
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
                    width: double.infinity,
                    color: Colors.black87,
                    height: 40,
                    child: Center(
                      child: Text(
                          "How many Shapes?",
                          style: TextStyle(
                              fontSize: _answerTextOffset,
                              fontFamily: _fontFamily,
                              color: Colors.white
                          )
                      ),
                    )
                ),
                Expanded(
                    child: Container(
                      color: Color(0xffececec),
                      child: GestureDetector(
                          onTapDown: (details) {
                            RenderBox box = context.findRenderObject();
                            final offset = box.globalToLocal(details.globalPosition);
                            print(offset);
                          },
                          child: CustomPaint(
                              painter: CountPainter(_shapePositions, _colorPositions, _shapeRadius, _shapeTypes),
                              child: Container()
                          )
                      )
                    )
                ),
                Container(
                    width: double.infinity,
                    color: Colors.black87,
                    height: 40,
                    child: Center(
                      child: Text(
                          "Answers",
                          style: TextStyle(
                              fontSize: _answerTextOffset,
                              fontFamily: _fontFamily,
                              color: Colors.white
                          )
                      ),
                    )
                ),
                Container(
                    color: Colors.black87,
                    width: double.infinity,
                    height: _answerButtonsOffset,
                    child: Center(
                      child: ButtonBar(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  if(int.parse(answerOneText) == _correctAnswer){
                                    setState((){
                                      _currentLevel = _currentLevel + 1;
                                    });
                                    _changeLevel = true;
                                  }
                                },
                                child: Text(
                                    answerOneText,
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
                                  if(int.parse(answerTwoText) == _correctAnswer){
                                    setState((){
                                      _currentLevel = _currentLevel + 1;
                                    });
                                    _changeLevel = true;
                                  }
                                },
                                child: Text(
                                    answerTwoText,
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
                                  if(int.parse(answerThreeText) == _correctAnswer){
                                    setState((){
                                      _currentLevel = _currentLevel + 1;
                                    });
                                    _changeLevel = true;
                                  }
                                },
                                child: Text(
                                    answerThreeText,
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
                                  if(int.parse(answerFourText) == _correctAnswer){
                                    setState((){
                                      _currentLevel = _currentLevel + 1;
                                    });
                                    _changeLevel = true;
                                  }
                                },
                                child: Text(
                                    answerFourText,
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
                                  if(int.parse(answerFiveText) == _correctAnswer){
                                    setState((){
                                      _currentLevel = _currentLevel + 1;
                                    });
                                    _changeLevel = true;
                                  }
                                },
                                child: Text(
                                    answerFiveText,
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
                    )
                )
              ],
            )
        ),
      );
    }
  }
}
