import 'package:notes_app/home.dart';
import 'package:flutter/material.dart';
import 'bloc.dart';
import 'notes_manager_bloc.dart';

void main() => runApp(Notes());

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<NoteManagerBloc>(
          bloc: NoteManagerBloc(),
          child: Home(),
        ));
  }
}
