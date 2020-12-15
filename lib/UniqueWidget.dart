import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'UniquePainter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UniqueWidget extends StatefulWidget {
  UniqueWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UniqueWidgetState createState() => _UniqueWidgetState();
}

class _UniqueWidgetState extends State<UniqueWidget> with TickerProviderStateMixin {
  Future<FirebaseApp> _initialization;
  final String highScoreCollection = "unique";

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
  final double _buttonWidth = 200;
  final int _msTimeLimit = 300000; //5 minutes total
  Stopwatch _gameTimer;
  int numMisses;
  final int penalty = 5000;
  int _currentLevel;
  int _currentShapeCombo;
  int _currentColorCombo;
  int _currentSizeCombo;
  int _correctSize;
  final String _fontFamily = "Satisfy";
  FToast answerResultToast;
  bool canSubmitInitials;
  bool submittedInitials;

  final _initialsSubmissionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //Since the game has to be played, this should be initialized by then
    if(_initialization == null){
      _initialization = Firebase.initializeApp();
    }

    numMisses = 0;

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
        }
        else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();

    _gameTimer = new Stopwatch();
    _gameTimer.start();

    answerResultToast = FToast();
    answerResultToast.init(context);

    _initialsSubmissionController.text = "";
  }

  void determineCorrectAnswer(){
    Random correctAnswerDecider = new Random();
    _correctAnswer = correctAnswerDecider.nextInt(4) + 1;
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
    _currentLevel = 1;
    canSubmitInitials = false;
    submittedInitials = false;
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

  void showAnswerResult(toastText){
      answerResultToast.removeCustomToast();
      answerResultToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.black87,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                toastText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: _fontFamily
                )
              ),
            ],
          ),
          ),
          toastDuration: Duration(seconds: 1),
          positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: 95,
            left: 160
          );
        }
      );
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

    if(this._currentLevel > 6){
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
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          'Total Misses: $numMisses',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          '${penalty / 1000} seconds per miss',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          'Score: ${((numMisses * penalty) + _gameTimer.elapsed.inMilliseconds)/1000}s',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
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
                              this.numMisses = 0;
                              this._initialsSubmissionController.text = "";
                              setState((){
                                canSubmitInitials = false;
                                submittedInitials = false;
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
                      this.submittedInitials ?
                      Text(
                          "submitted!",
                          style: TextStyle(
                              fontSize: 35,
                              fontFamily: _fontFamily,
                              color: Colors.white
                          )
                      ) :
                      Container(
                        width: this._buttonWidth,
                        child: ElevatedButton.icon(
                            onPressed: !this.canSubmitInitials ? null : () {
                              CollectionReference uniqueCollection = FirebaseFirestore.instance.collection(highScoreCollection);
                              uniqueCollection.add({
                                'initials': _initialsSubmissionController.text,
                                'score': ((numMisses * penalty) + _gameTimer.elapsed.inMilliseconds)
                              })
                              .then((value) => setState((){submittedInitials = true;}))
                              .catchError((error) => print("Failed to add document: $error"));
                            },
                            icon: Icon(Icons.list),
                            label: Text(
                              "SUBMIT SCORE",
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                            )
                        ),
                      ),
                      Container(
                          height: 10
                      ),
                      this.submittedInitials ?
                      Container() :
                      Container(
                        height: 50,
                        width: this._buttonWidth,
                        child: Theme(
                          data: new ThemeData(
                            primaryColor: Colors.white,
                            primaryColorDark: Colors.white,
                          ),
                          child: TextField(
                            controller: _initialsSubmissionController,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                            ],
                            maxLength: 3,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white
                                )
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                )
                              ),
                              labelText: 'enter initials',
                              counterText: "",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                decorationColor: Colors.white,
                                fontFamily: _fontFamily
                            ),
                            onChanged: (text) {
                              if(text.length > 0)
                                setState(() {
                                  canSubmitInitials = true;
                                });
                              else setState(() {
                                canSubmitInitials = false;
                              });
                            }
                          )
                        )
                      )
                    ]
                )
            ),
          )
      );
    }
    else{
      if(_changeLevel){
        updateLevelIcon();
        _shapeColorOne = getShapeColor();
        _shapeColorTwo = getDifferentShapeColor(_shapeColorOne);
        _currentShapeCombo = new Random().nextInt(2);
        _currentColorCombo = new Random().nextInt(2);
        _currentSizeCombo = new Random().nextInt(2);
        _correctSize = new Random().nextInt(3);
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
                    width: double.infinity,
                    color: Colors.black87,
                    height: 40,
                    child: Center(
                      child: Text(
                          "Which one is Unique?",
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: _fontFamily,
                              color: Colors.white
                          )
                      ),
                    )
                ),
                Expanded(
                    child: CustomPaint(
                        painter: UniquePainter(_shapePositions, _labelPositions, _currentLevel, _correctAnswer, _currentShapeCombo, _shapeColorOne, _shapeColorTwo, _currentColorCombo, _currentSizeCombo, _correctSize),
                        child: Container()
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
                              fontSize: 30,
                              fontFamily: _fontFamily,
                              color: Colors.white
                          )
                      ),
                    )
                ),
                Container(
                    color: Colors.black87,
                    width: double.infinity,
                    height: 50,
                    child: Center(
                        child: ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    if(_correctAnswer == 1){
                                      setState((){
                                        _currentLevel = _currentLevel + 1;
                                      });
                                      _changeLevel = true;
                                      showAnswerResult("Correct!");
                                    }
                                    else {
                                      numMisses++;
                                      showAnswerResult("Wrong!");
                                    }
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
                                    if(_correctAnswer == 2){
                                      setState((){
                                        _currentLevel = _currentLevel + 1;
                                      });
                                      _changeLevel = true;
                                      showAnswerResult("Correct!");
                                    }
                                    else {
                                      numMisses++;
                                      showAnswerResult("Wrong!");
                                    }
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
                                    if(_correctAnswer == 3){
                                      setState((){
                                        _currentLevel = _currentLevel + 1;
                                      });
                                      _changeLevel = true;
                                      showAnswerResult("Correct!");
                                    }
                                    else {
                                      numMisses++;
                                      showAnswerResult("Wrong!");
                                    }
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
                                    if(_correctAnswer == 4){
                                      setState((){
                                        _currentLevel = _currentLevel + 1;
                                      });
                                      _changeLevel = true;
                                      showAnswerResult("Correct!");
                                    }
                                    else {
                                      numMisses++;
                                      showAnswerResult("Wrong!");
                                    }
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
                                    if(_correctAnswer == 5){
                                      setState((){
                                        _currentLevel = _currentLevel + 1;
                                      });
                                      _changeLevel = true;
                                      showAnswerResult("Correct!");
                                    }
                                    else {
                                      numMisses++;
                                      showAnswerResult("Wrong!");
                                    }
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
                    )
                )
              ],
            )
        ),
      );
    }
  }
}