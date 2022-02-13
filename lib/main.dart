import 'package:firebase_todo_app/service/firebase_initialize.dart';
import 'package:flutter/material.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  final FireBaseInitialize _fireBaseInitialize = FireBaseInitialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: _fireBaseInitialize.firebaseInitialize(),
    );
  }
}
