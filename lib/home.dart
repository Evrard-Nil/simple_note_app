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
      body: _notes.isEmpty ? _emptyNotesBody() : _body(_notes),
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

Column _body(List<String> notes) {
  return Column(
    children: notes.map((String note) => Text(note)).toList(),
  );
}
