import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'ReactPainter.dart';

class ReactWidget extends StatefulWidget {
  ReactWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ReactWidgetState createState() => _ReactWidgetState();
}

class _ReactWidgetState extends State<ReactWidget> with TickerProviderStateMixin {
  Rect _rect;
  int _rectColor;
  int _prevRectColor;
  bool _updateRect;
  Animation<double> _animation;
  AnimationController _controller;
  final double _appBarOffSet = 50;
  final double _utilityBarOffset = 20;
  final double _bottomBarOffset = 45;
  final double _buttonWidth = 200;
  final int _msTimeLimit = 20000;
  Stopwatch _gameTimer;
  bool _gameOver;
  final String _fontFamily = "Satisfy";
  int _score;

  @override
  void initState() {
    super.initState();

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
                          '!! Results !!',
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontFamily: _fontFamily
                          )
                      ),
                      Text(
                          'Score: $_score',
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
                              setState((){
                                _score = 0;
                                _gameOver = false;
                              });
                              this._controller.reset();
                              this._controller.forward();
                              this._gameTimer.reset();
                              this._gameTimer.start();
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
      if(_updateRect){
        int rectSize = updateDifficulty(this._score);
        _rect = createRandomPositionRect(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height, rectSize);
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
                  Expanded(
                      child: GestureDetector(
                          onTapDown: (details) {
                            RenderBox box = context.findRenderObject();
                            final offset = box.globalToLocal(details.globalPosition);

                            Offset normalizedOffset = offset - Offset(0, this._appBarOffSet + this._utilityBarOffset);

                            final bool clickedOn = _rect.contains(normalizedOffset);
                            if (clickedOn) {
                              setState((){
                                this._score = this._score + 1;
                              });
                              _updateRect = true;
                            } else {
                              print("Missed");
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
