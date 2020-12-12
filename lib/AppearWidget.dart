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
  Rect rect;
  Animation<double> animation;
  AnimationController controller;
  final double _appBarOffSet = 50;
  final double _utilityBarOffset = 20;
  final double _buttonWidth = 200;
  bool _changeLevel;
  int _currentLevel;
  Stopwatch _gameTimer;
  Icon _currentLevelWidget;

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
    if(bottom < boxSize) bottom = bottom + boxSize;
    double top = bottom - boxSize;

    return Rect.fromLTRB(left,top,right,bottom);
  }

  _AppearWidgetState() {
    _currentLevel = 1;
  }

  int startNextLevel(int currentLevel){
    if(controller != null) controller.dispose();

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

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: animationDuration),
      // duration: Duration(seconds: 5),
    );

    Tween<double> _opacityTween = Tween(begin: startOpacity, end: endOpacity);
    // Tween<double> _rotationTween = Tween(begin: 0, end: .5);

    animation = _opacityTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
        else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();

    return boxSize;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(this._currentLevel > 5){
      _gameTimer.stop();
      controller.dispose();

      return Scaffold(
        appBar: AppBar(
          title: Text('Appear'),
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
                        fontFamily: 'Satisfy'
                    )
                ),
                Text(
                  'Time Elapsed: ${_gameTimer.elapsed.inMilliseconds / 1000}s',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: 'Satisfy'
                    )
                ),
                Container(
                    height: 30
                ),
                Container(
                  width: this._buttonWidth,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        /*...*/
                      },
                      icon: Icon(Icons.emoji_emotions_outlined),
                      label: Text(
                        "PLAY AGAIN",
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xffd5d6ea))
                      )
                  ),
                ),
                Container(
                  width: this._buttonWidth,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        /*...*/
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text(
                        "RETURN",
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xffd5d6ea))
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
        rect = createRandomPositionRect(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height, rectSize);
        this._changeLevel = false;
      }

      return Scaffold(
        appBar: AppBar(
          // leading: Text(
          //     "Level ${this._currentLevel.toString()}"
          // ),
          leading: _currentLevelWidget,
          title: Text('Appear'),
          actions: <Widget>[
            Text(
                "Timer (ms) |"
            ),
            Text(
                " ${_gameTimer.elapsed.inMilliseconds.toString()}"
            )
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

                            final bool clickedOn = rect.contains(normalizedOffset);
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
                              animation: animation,
                              builder: (context, snapshot) {
                                return CustomPaint(
                                    painter: AppearPainter(rect, animation.value),
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
