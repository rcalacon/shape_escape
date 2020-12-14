import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreClient{
  FirebaseFirestore firestore;

  StoreClient(){
    Firebase.initializeApp().then((res) => firestore = FirebaseFirestore.instance);
  }

  testQuery(){
    CollectionReference test = FirebaseFirestore.instance.collection('test');
    test.add({
      'key': 'value'
    })
    .then((value) => print("Data Added"))
    .catchError((error) => print("Failed to add document: $error"));
  }
}