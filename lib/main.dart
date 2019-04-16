import 'package:notes_app/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(Notes());

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
