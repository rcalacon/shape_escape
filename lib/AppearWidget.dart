import 'dart:convert';

import 'package:flutter/material.dart';
import 'OpenPainter.dart';

class AppearWidget extends StatefulWidget {
  AppearWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppearWidgetState createState() => _AppearWidgetState();
}

class _AppearWidgetState extends State<AppearWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 280,
          height: 320.0,
          child: CustomPaint(
            painter: OpenPainter(),
          ),
        ),
      )
    );
  }
}
