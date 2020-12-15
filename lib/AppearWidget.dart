import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'AppearPainter.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppearWidget extends StatefulWidget {
  AppearWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppearWidgetState createState() => _AppearWidgetState();
}

class _AppearWidgetState extends State<AppearWidget> with TickerProviderStateMixin {
  Future<FirebaseApp> _initialization;
  final String highScoreCollection = "appear";

  Rect _rect;
  Animation<double> _animation;
  AnimationController _controller;
  final double _appBarOffSet = 50;
  final double _utilityBarOffset = 20;
  final double _directionsOffset = 30;
  final double _bottomBarOffset = 45;
  final double _buttonWidth = 200;
  bool _changeLevel;
  int _currentLevel;
  Stopwatch _gameTimer;
  int numMisses;
  final int penalty = 5000;
  Icon _currentLevelWidget;
  final String _fontFamily = "Satisfy";
  FToast tapResultToast;

  //Canvas details fetched while debugging. Can probably improve this.
  final double canvasWidth = 411;
  final double canvasHeight = 569;

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

    _changeLevel = true;
    _currentLevelWidget = Icon(Icons.looks_one);
    _gameTimer = new Stopwatch();
    _gameTimer.start();

    tapResultToast = FToast();
    tapResultToast.init(context);

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

  _AppearWidgetState() {
    _currentLevel = 1;
    canSubmitInitials = false;
    submittedInitials = false;
  }

  void showTapResult(toastText){
    tapResultToast.removeCustomToast();
    tapResultToast.showToast(
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

  int startNextLevel(int currentLevel){
    if(_controller != null) _controller.dispose();

    double startOpacity = 0;
    double endOpacity;
    int animationDuration;
    int boxSize = 100;

    if(currentLevel == 1){
      endOpacity = 1;
      animationDuration = 5;
    }else if(currentLevel == 2){
      endOpacity = .4;
      animationDuration = 10;
      boxSize = 88;
      _currentLevelWidget = Icon(Icons.looks_two);
    }else if(currentLevel == 3){
      endOpacity = .3;
      animationDuration = 15;
      boxSize = 76;
      _currentLevelWidget = Icon(Icons.looks_3);
    }else if(currentLevel == 4){
      endOpacity = .2;
      animationDuration = 20;
      boxSize = 64;
      _currentLevelWidget = Icon(Icons.looks_4);
    }else if(currentLevel == 5){
      endOpacity = .15;
      animationDuration = 25;
      boxSize = 50;
      _currentLevelWidget = Icon(Icons.looks_5);
    }

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: animationDuration),
    );

    Tween<double> _opacityTween = Tween(begin: startOpacity, end: endOpacity);

    _animation = _opacityTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.forward();
        }
        else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();

    return boxSize;
  }

  @override
  void dispose() {
    if(_controller != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(this._currentLevel > 5){
      _gameTimer.stop();
      if(_controller != null){
        _controller.dispose();
        _controller = null;
      }

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
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
                        this._controller = null;
                        this._gameTimer.reset();
                        this._gameTimer.start();
                        this.numMisses = 0;
                        _initialsSubmissionController.text = "";
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
                        CollectionReference appearCollection = FirebaseFirestore.instance.collection(highScoreCollection);
                        appearCollection.add({
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
    else {
      if(this._changeLevel == true){
        int rectSize = startNextLevel(this._currentLevel);
        _rect = createRandomPositionRect(rectSize);
        this._changeLevel = false;
      }

      return Scaffold(
        appBar: AppBar(
          leading: _currentLevelWidget,
          title: Text(
            'Appear',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: _fontFamily,
                  fontSize: 30
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      color: Colors.black87,
                      height: 40,
                      child: Center(
                        child: Text(
                            "Click the Shape!",
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
                              showTapResult("! Nice !");
                              this._changeLevel = true;
                              setState((){
                                this._currentLevel = this._currentLevel + 1;
                              });
                            } else {
                              numMisses++;
                              showTapResult("Missed!");
                            }
                          },
                          child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, snapshot) {
                                return CustomPaint(
                                    painter: AppearPainter(_rect, _animation.value),
                                    child: Container()
                                );
                              }
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
