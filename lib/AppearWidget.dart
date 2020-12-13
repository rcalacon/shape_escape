import 'package:flutter/material.dart';
import 'dart:math';
import 'AppearPainter.dart';

class AppearWidget extends StatefulWidget {
  AppearWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppearWidgetState createState() => _AppearWidgetState();
}

class _AppearWidgetState extends State<AppearWidget> with TickerProviderStateMixin {
  Rect _rect;
  Animation<double> _animation;
  AnimationController _controller;
  final double _appBarOffSet = 50;
  final double _utilityBarOffset = 20;
  final double _bottomBarOffset = 45;
  final double _buttonWidth = 200;
  bool _changeLevel;
  int _currentLevel;
  Stopwatch _gameTimer;
  Icon _currentLevelWidget;
  final String _fontFamily = "Satisfy";

  @override
  void initState() {
    super.initState();

    _changeLevel = true;
    _currentLevelWidget = Icon(Icons.looks_one);
    _gameTimer = new Stopwatch();
    _gameTimer.start();
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

  _AppearWidgetState() {
    _currentLevel = 1;
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
      _controller.dispose();
      _controller = null;

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
                    '!! Results !!',
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
    else {
      if(this._changeLevel == true){
        int rectSize = startNextLevel(this._currentLevel);
        _rect = createRandomPositionRect(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height, rectSize);
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
                  Expanded(
                      child: GestureDetector(
                          onTapDown: (details) {
                            RenderBox box = context.findRenderObject();
                            final offset = box.globalToLocal(details.globalPosition);

                            Offset normalizedOffset = offset - Offset(0, this._appBarOffSet + this._utilityBarOffset);

                            final bool clickedOn = _rect.contains(normalizedOffset);
                            if (clickedOn) {
                              this._changeLevel = true;
                              setState((){
                                this._currentLevel = this._currentLevel + 1;
                              });
                            } else {
                              print("Missed");
                            }
                          },
                          child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, snapshot) {
                                return CustomPaint(
                                    painter: ReactPainter(_rect, _animation.value),
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
