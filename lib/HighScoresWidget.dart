import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String appearCollectionName = "appear";
const String reactCollectionName = "react";
const String countCollectionName = "count";
const String uniqueCollectionName = "unique";
const String stackCollectionName = "stack";

const APPEAR_COLOR = Color(0xffe0bbe4);
const REACT_COLOR = Color(0xff957dad);
const COUNT_COLOR = Color(0xffd291bc);
const UNIQUE_COLOR = Color(0xfffec8d8);
const STACK_COLOR = Color(0xffffccb6);

class HighScoresWidget extends StatefulWidget {
  HighScoresWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HighScoresWidgetState createState() => _HighScoresWidgetState();
}

class _HighScoresWidgetState extends State<HighScoresWidget> {
  Future<FirebaseApp> _initialization;

  final String _fontFamily = "Satisfy";
  final String _title = "High Scores";
  String _currentScoreList;
  Color _currentScoreListHeaderColor;
  TextStyle headerStyle;
  TextStyle entryStyle;
  List _scores;

  _HighScoresWidgetState() {
    _scores = [];
    _currentScoreList = "appear";
    _currentScoreListHeaderColor = APPEAR_COLOR;
  }

  @override
  void initState() {
    super.initState();

    _initialization = Firebase.initializeApp();
    _initialization.then((res) {
      getScores(appearCollectionName);
    });
    headerStyle = TextStyle(
      color: Colors.white,
      fontFamily: _fontFamily,
      fontSize: 33
    );
    entryStyle = TextStyle(
        color: Colors.white,
        fontFamily: _fontFamily,
        fontSize: 28
    );
  }

  getScores(collection){
    List fetchedScores = new List();
    Color gameColor;
    bool shouldDescend = false;

    switch(collection){
      case appearCollectionName: {
        gameColor = APPEAR_COLOR;
        break;
      }
      case reactCollectionName: {
        shouldDescend = true;
        gameColor = REACT_COLOR;
        break;
      }
      case countCollectionName: {
        gameColor = COUNT_COLOR;
        break;
      }
      case uniqueCollectionName: {
        gameColor = UNIQUE_COLOR;
        break;
      }
      case stackCollectionName: {
        gameColor = STACK_COLOR;
        break;
      }
    }

    FirebaseFirestore.instance
        .collection(collection)
        .orderBy('score', descending: shouldDescend)
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        fetchedScores.add([doc["initials"], doc["score"]]);
      });
      setState(() {
        _scores = fetchedScores;
        _currentScoreList = collection;
        _currentScoreListHeaderColor = gameColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_title,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: _fontFamily)),
            ),
            body: Container(
              color: Colors.black87,
              child: Center(
                  child: Text("Something went wrong...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: _fontFamily))),
            ),
          );
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.list),
              title: Text(_title,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: _fontFamily)),
            ),
            body: Container(
              color: Colors.black87,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _currentScoreList,
                    style: TextStyle(
                        color: _currentScoreListHeaderColor,
                        fontFamily: _fontFamily,
                        fontSize: 35
                    )
                  ),
                  Expanded(
                    child: Table(
                      border: TableBorder.all(
                        color: Colors.white70
                      ),
                      children: [
                        TableRow(children: [
                          Center(child: Text("Rank", style:headerStyle)),
                          Center(child: Text("Initials", style:headerStyle)),
                          Center(child: Text("Score", style:headerStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("1", style:entryStyle)),
                          Center(child: Text(_scores.length > 0 ? _scores[0][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 0 ? (_currentScoreList == "react" ? _scores[0][1].toString() : (_scores[0][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("2", style:entryStyle)),
                          Center(child: Text(_scores.length > 1 ? _scores[1][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 1 ? (_currentScoreList == "react" ? _scores[1][1].toString() : (_scores[1][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("3", style:entryStyle)),
                          Center(child: Text(_scores.length > 2 ? _scores[2][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 2 ? (_currentScoreList == "react" ? _scores[2][1].toString() : (_scores[2][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("4", style:entryStyle)),
                          Center(child: Text(_scores.length > 3 ? _scores[3][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 3 ? (_currentScoreList == "react" ? _scores[3][1].toString() : (_scores[3][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("5", style:entryStyle)),
                          Center(child: Text(_scores.length > 4 ? _scores[4][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 4 ? (_currentScoreList == "react" ? _scores[4][1].toString() : (_scores[4][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("6", style:entryStyle)),
                          Center(child: Text(_scores.length > 5 ? _scores[5][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 5 ? (_currentScoreList == "react" ? _scores[5][1].toString() : (_scores[5][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("7", style:entryStyle)),
                          Center(child: Text(_scores.length > 6 ? _scores[6][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 6 ? (_currentScoreList == "react" ? _scores[6][1].toString() : (_scores[6][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("8", style:entryStyle)),
                          Center(child: Text(_scores.length > 7 ? _scores[7][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 7 ? (_currentScoreList == "react" ? _scores[7][1].toString() : (_scores[7][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("9", style:entryStyle)),
                          Center(child: Text(_scores.length > 8 ? _scores[8][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 8 ? (_currentScoreList == "react" ? _scores[8][1].toString() : (_scores[8][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                        TableRow(children: [
                          Center(child: Text("10", style:entryStyle)),
                          Center(child: Text(_scores.length > 9 ? _scores[9][0] : "", style:entryStyle)),
                          Center(child: Text(_scores.length > 9 ? (_currentScoreList == "react" ? _scores[9][1].toString() : (_scores[9][1]/1000).toStringAsFixed(2) + "s") : "", style:entryStyle))
                        ]),
                      ]
                    )
                  ),
                  Container(
                      width: double.infinity,
                      color: Colors.black87,
                      height: 40,
                      child: Center(
                        child: Text("Games",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: _fontFamily,
                                color: Colors.white)),
                      )),
                  Container(
                      color: Colors.black87,
                      width: double.infinity,
                      height: 50,
                      child: Center(
                          child: ButtonBar(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                            ElevatedButton(
                                onPressed: _currentScoreList == "appear" ? null : () {getScores("appear");},
                                child: Text("APPEAR",
                                    style: TextStyle(
                                        fontSize: 10, fontFamily: _fontFamily)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            APPEAR_COLOR))),
                            ElevatedButton(
                                onPressed: _currentScoreList == "react" ? null : () {getScores("react");},
                                child: Text("REACT",
                                    style: TextStyle(
                                        fontSize: 10, fontFamily: _fontFamily)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            REACT_COLOR))),
                            ElevatedButton(
                                onPressed: _currentScoreList == "count" ? null : () {getScores("count");},
                                child: Text("COUNT",
                                    style: TextStyle(
                                        fontSize: 10, fontFamily: _fontFamily)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            COUNT_COLOR))),
                            ElevatedButton(
                                onPressed: _currentScoreList == "unique" ? null : () {getScores("unique");},
                                child: Text("UNIQUE",
                                    style: TextStyle(
                                        fontSize: 10, fontFamily: _fontFamily)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            UNIQUE_COLOR))),
                            ElevatedButton(
                                onPressed: _currentScoreList == "stack" ? null : () {getScores("stack");},
                                child: Text("STACK",
                                    style: TextStyle(
                                        fontSize: 10, fontFamily: _fontFamily)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            STACK_COLOR))),
                          ])))
                ],
              )),
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        else
          return Scaffold(
            appBar: AppBar(
              title: Text(_title,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: _fontFamily)),
            ),
            body: Container(
              color: Colors.black87,
              child: Center(
                  child: Text("Loading Scores...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: _fontFamily))),
            ),
          );
      },
    );
  }
}
