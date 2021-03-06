import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppearWidget.dart';
import 'ReactWidget.dart';
import 'CountWidget.dart' as ShapeEscape;
import 'UniqueWidget.dart' as ShapeEscape;
import 'HighScoresWidget.dart';
import 'StackWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shape Escape',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Escape The Shapes!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _buttonWidth = 120;
  double _highScoreButtonWidth = 200;
  final String _fontFamily = "Satisfy";
  String test;
  @override
  void initState(){
    super.initState();

  }

  _MyHomePageState() {
    test = "test";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.title,
            style: TextStyle(
                fontFamily: _fontFamily
            )
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Shape Escape',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontFamily: _fontFamily
                  )
              ),
              Image(
                //fit: BoxFit.scaleDown,
                height: 100,
                image: AssetImage('assets/logo.png')
              ),
              Container(
                height: 30
              ),
              Container(
                width: this._buttonWidth,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppearWidget())
                      );
                    },
                    icon: Icon(Icons.crop_square_sharp),
                    label: Text(
                      "APPEAR",
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffe0bbe4))
                    )
                ),
              ),
              Container(
                width: this._buttonWidth,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReactWidget())
                      );
                    },
                    icon: Icon(Icons.access_alarm),
                    label: Text(
                      "REACT",
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xff957dad))
                    )
                ),
              ),
              Container(
                width: this._buttonWidth,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShapeEscape.CountWidget())
                      );
                    },
                    icon: Icon(Icons.apps_rounded),
                    label: Text(
                      "COUNT",
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffd291bc))
                    )
                ),
              ),
              Container(
                width: this._buttonWidth,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShapeEscape.UniqueWidget())
                      );
                    },
                    icon: Icon(Icons.ac_unit),
                    label: Text(
                      "UNIQUE",
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xfffec8d8))
                    )
                ),
              ),
              Container(
                width: this._buttonWidth,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StackWidget())
                      );
                    },
                    icon: Icon(
                        Icons.view_headline,
                    ),
                    label: Text(
                      "STACK",
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffccb6))
                    )
                ),
              ),
              Container(
                  height: 30
              ),
              Container(
                width: this._highScoreButtonWidth,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HighScoresWidget())
                      );
                    },
                    icon: Icon(Icons.list),
                    label: Text(
                      "HIGH SCORES",
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xff8fcaca))
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
