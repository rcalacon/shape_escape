import 'package:flutter/material.dart';

import 'AppearWidget.dart';
import 'ReactWidget.dart';
import 'UniqueWidget.dart' as ShapeEscape;

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

  @override
  Widget build(BuildContext context) {
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
                  '!! Play Something !!',
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
                      /*...*/
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
                      /*...*/
                    },
                    icon: Icon(Icons.cached),
                    label: Text(
                      "MATCH",
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
                      /*...*/
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
