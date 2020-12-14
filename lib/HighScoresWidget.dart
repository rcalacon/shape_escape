import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HighScoresWidget extends StatefulWidget {
  HighScoresWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HighScoresWidget createState() => _HighScoresWidget();
}

class _HighScoresWidget extends State<HighScoresWidget> {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(
              "Something went wrong.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              )
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return FlatButton(
              child: Text("Send Query",
                style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              )),
              onPressed: () {
                CollectionReference test = FirebaseFirestore.instance.collection('test');
                test.add({
                  'key': 'value'
                })
                    .then((value) => print("Data Added"))
                    .catchError((error) => print("Failed to add document: $error"));
              }
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text("Loading",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ));
      },
    );
  }
}