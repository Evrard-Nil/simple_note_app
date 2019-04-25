import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/home_comp/appbar.dart';
import 'package:notes_app/src/Bloc/bloc.dart';
import 'package:notes_app/src/Bloc/notes_manager_bloc.dart';
import 'package:notes_app/src/View/home_comp/body.dart';
import 'package:notes_app/src/View/home_comp/push_note.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final NoteManagerBloc bloc = BlocProvider.of<NoteManagerBloc>(context);

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(bloc),
      floatingActionButton: buildFloatingActionButton(context, bloc),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context, NoteManagerBloc bloc) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: const Text('Add note'),
      onPressed: () {
        final Future<String> newNote = pushNote(context);
        newNote.then((String onValue) {
          if (onValue.isNotEmpty) {
            bloc.inAddNotes.add(onValue);
          }
        });
      },
    );
  }
}
