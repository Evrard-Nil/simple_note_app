import 'package:flutter/material.dart';
import 'package:notes_app/src/Bloc/bloc.dart';
import 'package:notes_app/src/Bloc/notes_manager_bloc.dart';
import 'package:notes_app/src/View/home.dart';

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
