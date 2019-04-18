import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _notes = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: _notes.isEmpty ? _emptyNotesBody() : _body(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
        onPressed: () {
          final Future<String> newNote = _pushNote(context);
          newNote.then((String onValue) {
            _notes.add(onValue);
            setState(() {});
          });
        },
      ),
    );
  }

  Column _body() {
    return Column(
      children: _notes.map((String note) {
        return Dismissible(
          key: UniqueKey(),
          child: Text(note),
          onDismissed: (DismissDirection direction) {
            _notes.remove(note);
            setState(() {});
          },
        );
      }).toList(),
    );
  }
}

Future<String> _pushNote(BuildContext context) async {
  return Navigator.of(context).push(MaterialPageRoute<String>(builder: (BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
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
