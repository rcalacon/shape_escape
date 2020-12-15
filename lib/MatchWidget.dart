import 'package:flutter/material.dart';

class MatchWidget extends StatefulWidget {
  MatchWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MatchWidgetState createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {

  final String _fontFamily = "Satisfy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match",
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontFamily: _fontFamily)),
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
            child: Text("match game\ncoming soon!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: _fontFamily))),
      ),
    );
  }
}
