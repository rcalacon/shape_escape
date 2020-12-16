import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'StackPainter.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const COLOR_OPTION_ONE = Color(0xffe0bbe4);
const COLOR_OPTION_TWO = Color(0xff957dad);
const COLOR_OPTION_THREE = Color(0xffd291bc);
const COLOR_OPTION_FOUR = Color(0xfffec8d8);
const COLOR_OPTION_FIVE = Color(0xffffccb6);

class StackWidget extends StatefulWidget {
  StackWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StackWidgetState createState() => _StackWidgetState();
}

class _StackWidgetState extends State<StackWidget> with TickerProviderStateMixin {
  Future<FirebaseApp> _initialization;
  final String highScoreCollection = "stack";

  List _stacks;
  List _stackColors;
  Rect initialStack;
  final double _beginningRectWidth = 150;
  final double _rectHeight = 50;
  final double _firstStackBottomPositionY = 519;
  double _newStackBottomPositionY;
  double _newRectWidth;
  Color _newRectColor;
  Rect _trimmedStack;
  Animation<double> _animation;
  final int animationDuration = 1;
  AnimationController _controller;
  final double _appBarOffSet = 50;
  final double _directionsOffset = 30;
  final double _buttonWidth = 200;
  final int _lastLevel = 8;
  bool _changeLevel;
  int _currentLevel;
  bool gameOver;
  final String _fontFamily = "Satisfy";
  FToast stackResultToast;

  //Canvas details fetched while debugging. Can probably improve this.
  final double canvasWidth = 411;
  final double canvasHeight = 519;

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

    initialStack = new Rect.fromLTRB(130,469,280,519);

    _stacks = new List();
    _stacks.add(initialStack);

    _stackColors = new List();
    _stackColors.add(getRandomColor());

    _newRectWidth = _beginningRectWidth;
    _newStackBottomPositionY = _firstStackBottomPositionY;

    _newRectColor = getRandomColor();

    _changeLevel = true;

    stackResultToast = FToast();
    stackResultToast.init(context);

    _initialsSubmissionController.text = "";
  }

  _StackWidgetState() {
    _currentLevel = 1;
    canSubmitInitials = false;
    submittedInitials = false;
    gameOver = false;
  }

  Color getRandomColor(){
    switch(new Random().nextInt(5)){
      case 0: {
        return COLOR_OPTION_ONE;
      }
      case 1: {
        return COLOR_OPTION_TWO;
      }
      case 2: {
        return COLOR_OPTION_THREE;
      }
      case 3: {
        return COLOR_OPTION_FOUR;
      }
      case 4: {
        return COLOR_OPTION_FIVE;
      }
      default: {
        return COLOR_OPTION_ONE;
      }
    }
  }

  void showStackResult(toastText){
    stackResultToast.removeCustomToast();
    stackResultToast.showToast(
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
              bottom: 50,
              left: 165
          );
        }
    );
  }

  Rect validateStack(){
    double stackAttemptLeft = _animation.value - (_newRectWidth / 2);
    double stackAttemptRight = _animation.value + (_newRectWidth / 2);

    Rect lastStack;
    if(_currentLevel == 1){
      lastStack = initialStack;
    }else{
      lastStack = _stacks[_stacks.length - 1];
    }

    if(stackAttemptLeft < lastStack.left && stackAttemptRight < lastStack.left ||
        stackAttemptLeft > lastStack.right && stackAttemptRight > lastStack.right){
      return null;
    }else{
      if(stackAttemptLeft < lastStack.left) {
        stackAttemptLeft = lastStack.left;
      }
      if(stackAttemptRight > lastStack.right) {
        stackAttemptRight = lastStack.right;
      }
      _newRectWidth = stackAttemptRight - stackAttemptLeft;
      return Rect.fromLTRB(stackAttemptLeft, _newStackBottomPositionY - _rectHeight, stackAttemptRight, _newStackBottomPositionY);
    }
  }

  startNextLevel(int currentLevel){
    if(_controller != null) _controller.dispose();

    if(currentLevel != 1) {
      _stacks.add(_trimmedStack);
      _stackColors.add(_newRectColor);
      _newRectColor = getRandomColor();
    }

    _newStackBottomPositionY -= _rectHeight;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: animationDuration),
    );

    int initialDirectionDecider = new Random().nextInt(2);

    double beginning;
    double ending;
    if(initialDirectionDecider == 0){
      beginning = (0 + (_beginningRectWidth / 2));
      ending = canvasWidth - (_beginningRectWidth/2);
    }else {
      beginning = canvasWidth - (_beginningRectWidth/2);
      ending = (0 + (_beginningRectWidth / 2));
    }

    Tween<double> _opacityTween = Tween(begin: beginning, end: ending);

    _animation = _opacityTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
        else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    if(_controller != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(this._currentLevel > _lastLevel || this.gameOver){
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
                'Stack',
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
                          'Number of Stacks: $_currentLevel',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          '10 points per stack',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                        'Length of last Stack: ${(_trimmedStack.right - _trimmedStack.left).toInt()}px',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                        '1 bonus point per pixel',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          'Score: ${((_currentLevel * 10) + _trimmedStack.right - _trimmedStack.left).toInt()}',
                          style: TextStyle(
                              fontSize: 35,
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
                              this._stacks.clear();
                              this._stacks.add(initialStack);
                              this._stackColors.clear();
                              this._stackColors.add(getRandomColor());
                              this._newRectWidth = _beginningRectWidth;
                              this._newStackBottomPositionY = _firstStackBottomPositionY;
                              _initialsSubmissionController.text = "";
                              setState((){
                                canSubmitInitials = false;
                                submittedInitials = false;
                                _currentLevel = 1;
                                gameOver = false;
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
                                'score': ((_currentLevel * 10) + (_trimmedStack.right - _trimmedStack.left)).toInt()
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
        startNextLevel(this._currentLevel);
        this._changeLevel = false;
      }

      return Scaffold(
        appBar: AppBar(
          leading: Text(
              "  ${_currentLevel.toString()}",
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 35,
              )
          ),
          title: Text(
              'Stack',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: _fontFamily,
                  fontSize: 30
              )
          ),
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
                      child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, snapshot) {
                            return CustomPaint(
                                painter: StackPainter(_newRectWidth, _animation.value, _newStackBottomPositionY, _newRectColor, _stacks, _stackColors, _rectHeight),
                                child: Container()
                            );
                          }
                      )
                  ),
                  Container(
                      color: Colors.black87,
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: ElevatedButton(
                            onPressed: () {
                              Rect validStack = validateStack();
                              if(validStack != null) {
                                showStackResult("! Nice !");
                                this._changeLevel = true;
                                this._trimmedStack = validStack;
                                setState(() {
                                  _currentLevel = _currentLevel + 1;
                                });
                              }else {
                                showStackResult("! Miss !");
                                this._changeLevel = false;
                                setState(() {
                                  this.gameOver = true;
                                });
                              }
                            },
                            child: Text(
                                "stack!",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: _fontFamily
                                )
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffccb6))
                            )
                        ),
                      )
                  )
                ]
            )
        ),
      );
    }
  }
}
