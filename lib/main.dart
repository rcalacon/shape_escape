import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Escape the shapes!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                    icon: Icon(Icons.brightness_1),
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
                      /*...*/
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
                      /*...*/
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
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffdfd3))
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
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffd5d6ea))
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
