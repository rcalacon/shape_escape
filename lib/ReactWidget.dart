import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'ReactPainter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReactWidget extends StatefulWidget {
  ReactWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ReactWidgetState createState() => _ReactWidgetState();
}

class _ReactWidgetState extends State<ReactWidget> with TickerProviderStateMixin {
  Future<FirebaseApp> _initialization;
  final String highScoreCollection = "react";

  Rect _rect;
  int _rectColor;
  int _prevRectColor;
  bool _updateRect;
  Animation<double> _animation;
  AnimationController _controller;
  final double _appBarOffSet = 50;
  final double _utilityBarOffset = 20;
  final double _directionsOffset = 30;
  final double _bottomBarOffset = 45;
  final double _buttonWidth = 200;
  final int _msTimeLimit = 20000;
  Stopwatch _gameTimer;
  bool _gameOver;
  final String _fontFamily = "Satisfy";
  FToast answerResultToast;
  int _score;
  int numMisses;
  final int penalty = 1;
  bool canSubmitInitials;
  bool submittedInitials;

  final _initialsSubmissionController = TextEditingController();

  //Canvas details fetched while debugging. Can probably improve this.
  final double canvasWidth = 411;
  final double canvasHeight = 569;

  @override
  void initState() {
    super.initState();

    //Since the game has to be played, this should be initialized by then
    if(_initialization == null){
      _initialization = Firebase.initializeApp();
    }

    numMisses = 0;
    _updateRect = true;

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
          _updateRect = false;
          setState(() {
            canSubmitInitials = false;
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

    answerResultToast = FToast();
    answerResultToast.init(context);

    _initialsSubmissionController.text = "";
  }

  Rect createRandomPositionRect(int boxSize){
    Random rectPositionDecider = new Random();

    double right = rectPositionDecider.nextInt(canvasWidth.toInt()).toDouble();
    if(right < boxSize) right = right + boxSize;
    double left = right - boxSize;

    double bottom = rectPositionDecider.nextInt(canvasHeight.toInt()).toDouble();
    if(bottom < (boxSize)) bottom = bottom + boxSize;
    double top = bottom - boxSize;

    return Rect.fromLTRB(left,top,right,bottom);
  }

  int getNewRectColor(){
    Random rectColorDecider = new Random();

    int colorResult = rectColorDecider.nextInt(5);
    if(_prevRectColor != null){
      while(_prevRectColor == colorResult){
        colorResult = rectColorDecider.nextInt(5);
      }
    }

    _prevRectColor = colorResult;
    return colorResult;
  }

  _ReactWidgetState() {
    _score = 0;
    _gameOver = false;
    canSubmitInitials = false;
    submittedInitials = false;
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
              bottom: 15,
              left: 160
          );
        }
    );
  }

  int updateDifficulty(int score){
    int targetSize = 100;

    if(score >= 5){
      targetSize = 90;
    }if(score >= 10){
      targetSize = 80;
    }if(score >= 15){
      targetSize = 70;
    }if(score >= 20){
      targetSize = 60;
    }if(score >= 25){
      targetSize = 50;
    }

    return targetSize;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(this._gameOver){
      _gameTimer.stop();

      return Scaffold(
          appBar: AppBar(
            title: Text(
                'Appear',
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
                          'Hits: $_score',
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
                          '-$penalty per miss',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          'Score: ${_score - (numMisses * penalty)}',
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Container(
                        width: this._buttonWidth,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              this._controller.reset();
                              this._controller.forward();
                              this._gameTimer.reset();
                              this._gameTimer.start();
                              this._initialsSubmissionController.text = "";
                              this.numMisses = 0;
                              setState((){
                                _score = 0;
                                submittedInitials = false;
                                _gameOver = false;
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
                              CollectionReference reactCollection = FirebaseFirestore.instance.collection(highScoreCollection);
                              reactCollection.add({
                                'initials': _initialsSubmissionController.text,
                                'score': _score - numMisses
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
      if(_updateRect){
        int rectSize = updateDifficulty(this._score);
        _rect = createRandomPositionRect(rectSize);
        _rectColor = getNewRectColor();

        _updateRect = false;
      }

      return Scaffold(
        appBar: AppBar(
          leading: Text(
              "  ${_score.toString()}",
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 35,
              )
          ),
          title: Text(
              'React',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 30,
              )
          ),
          actions: <Widget>[
            Text(
                " ${((_msTimeLimit - _gameTimer.elapsed.inMilliseconds) / 1000).toStringAsFixed(1)}",
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 30,
                )
            ),
            Text(
                "  Seconds Left! ",
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 25,
                )
            )
          ],
          toolbarHeight: this._appBarOffSet,
        ),
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      color: Colors.black87,
                      height: 40,
                      child: Center(
                        child: Text(
                            "Keep clicking the Shape!",
                            style: TextStyle(
                                fontSize: _directionsOffset,
                                fontFamily: _fontFamily,
                                color: Colors.white
                            )
                        ),
                      )
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTapDown: (details) {
                            RenderBox box = context.findRenderObject();
                            final offset = box.globalToLocal(details.globalPosition);

                            int manualOffset = 15;
                            Offset normalizedOffset = offset - Offset(0, this._appBarOffSet + this._utilityBarOffset + this._directionsOffset + manualOffset);

                            final bool clickedOn = _rect.contains(normalizedOffset);
                            if (clickedOn) {
                              showAnswerResult("! Nice !");
                              setState((){
                                this._score = this._score + 1;
                              });
                              _updateRect = true;
                            } else {
                              showAnswerResult("Missed!");
                              numMisses ++;
                            }
                          },
                          child: CustomPaint(
                              painter: ReactPainter(_rect, _rectColor),
                              child: Container()
                          )
                      )
                  ),
                ]
            )
        ),
      );
    }
  }
}
