import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  BehaviorSubject<List<String>> _notes;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences onValue) {
      _notes.add(onValue.getStringList('simple_notes_app_notes'));
    });
    super.initState();
  }

  @override
  void dispose() {
    SharedPreferences.getInstance().then((SharedPreferences onValue) {
      onValue.setStringList('simple_notes_app_notes', _notes.stream.value ?? <String>[]);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: StreamBuilder(
        stream: _notes.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
        onPressed: () {
          final Future<String> newNote = _pushNote(context);
          newNote.then((String onValue) {
            if (onValue.isNotEmpty) {
              _notes.add(onValue);
            }
          });
        },
      ),
    );
  }

  Column _body(List<String>notes) {
    return Column(
      children: notes.map((String note) {
        return Dismissible(
          key: UniqueKey(),
          child: FlatButton(
            child: Text(note),
            onPressed: () {
              _pushNote(context, note).then((String onValue) {
                _notes.remove(note);
                _notes.add(onValue);
              });
            },
          ),
          onDismissed: (DismissDirection direction) {
            _notes.remove(note);
            setState(() {});
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
