import 'package:flutter/material.dart';
import 'package:notes_app/src/Bloc/notes_manager_bloc.dart';
import 'package:notes_app/src/View/home_comp/push_note.dart';

StreamBuilder<List<Map<String, dynamic>>> buildBody(NoteManagerBloc bloc) {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: bloc.outNotes,
    builder: (BuildContext context,
        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData && snapshot.data.isNotEmpty) {
        return _body(context, snapshot.data, bloc);
      } else
        return _emptyNotesBody();
    },
  );
}

Widget _body(BuildContext context, List<Map<String, dynamic>> notes,
    NoteManagerBloc bloc) {
  Widget noteCard(Map<String, dynamic> note) {
    return Dismissible(
      key: UniqueKey(),
      child: GestureDetector(
        child: Card(
          child: SizedBox(
            height: 90,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    note['content'],
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          pushNote(context, note).then((Map<String, dynamic> onValue) {
            bloc.inRmNotes.add(note);
            bloc.inAddNotes.add(onValue);
          });
        },
      ),
      onDismissed: (DismissDirection direction) {
        bloc.inRmNotes.add(note);
      },
      secondaryBackground: Container(
        color: Colors.red,
      ),
      background: Container(color: Colors.cyan),
    );
  }

  return ListView.builder(
    itemCount: notes.length,
    itemBuilder: (BuildContext context, int index) {
      return noteCard(notes[index]);
    },
  );
}

Text _emptyNotesBody() {
  return const Text('Empty note list');
}
