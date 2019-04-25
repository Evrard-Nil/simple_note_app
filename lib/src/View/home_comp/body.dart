import 'package:flutter/material.dart';
import 'package:notes_app/src/Bloc/notes_manager_bloc.dart';
import 'package:notes_app/src/View/home_comp/push_note.dart';

StreamBuilder<List<String>> buildBody(NoteManagerBloc bloc) {
  return StreamBuilder<List<String>>(
    stream: bloc.outNotes,
    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
      if (snapshot.hasData && snapshot.data.isNotEmpty) {
        return _body(context, snapshot.data, bloc);
      } else
        return _emptyNotesBody();
    },
  );
}

Column _body(BuildContext context, List<String> notes, NoteManagerBloc bloc) {
  return Column(
    children: notes.map((String note) {
      return Dismissible(
        key: UniqueKey(),
        child: FlatButton(
          child: Text(note),
          onPressed: () {
            pushNote(context, note).then((String onValue) {
              bloc.inRmNotes.add(note);
              bloc.inAddNotes.add(onValue);
            });
          },
        ),
        onDismissed: (DismissDirection direction) {
          bloc.inRmNotes.add(note);
        },
      );
    }).toList(),
  );
}

Text _emptyNotesBody() {
  return const Text('Empty note list');
}
