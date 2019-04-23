import 'dart:async';
import 'package:flutter/material.dart';
import 'bloc.dart';
import 'notes_manager_bloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final NoteManagerBloc bloc = BlocProvider.of<NoteManagerBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: StreamBuilder<List<String>>(
        stream: bloc.outNotes,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return _body(snapshot.data, bloc);
          } else
            return _emptyNotesBody();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
        onPressed: () {
          final Future<String> newNote = _pushNote(context);
          newNote.then((String onValue) {
            if (onValue.isNotEmpty) {
              bloc.inAddNotes.add(onValue);
            }
          });
        },
      ),
    );
  }

  Column _body(List<String> notes, NoteManagerBloc bloc) {
    return Column(
      children: notes.map((String note) {
        return Dismissible(
          key: UniqueKey(),
          child: FlatButton(
            child: Text(note),
            onPressed: () {
              _pushNote(context, note).then((String onValue) {
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
}

Future<String> _pushNote(BuildContext context, [String note = '']) async {
  return Navigator.of(context).push(MaterialPageRoute<String>(builder: (BuildContext context) {
    final TextEditingController _controller = TextEditingController(text: note);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(note);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('New note'),
      ),
      body: TextField(
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter your note ...'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          Navigator.of(context).pop(_controller.text);
        },
      ),
    );
  }));
}

Text _emptyNotesBody() {
  return const Text('Empty note list');
}
