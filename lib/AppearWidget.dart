import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'OpenPainter.dart';

class AppearWidget extends StatefulWidget {
  AppearWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppearWidgetState createState() => _AppearWidgetState();
}

class _AppearWidgetState extends State<AppearWidget> with TickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );

    Tween<double> _rotationTween = Tween(begin: 0, end: .15);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appear')
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, snapshot) {
                    return CustomPaint(
                        painter: OpenPainter(animation.value),
                        child: Container()
                    );
                  }
              )
            ),
          ]
        )
      ),
    );
  }
}
