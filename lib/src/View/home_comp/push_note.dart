import 'package:flutter/material.dart';

Future<Map<String, dynamic>> pushNote(BuildContext context,
    [Map<String, dynamic> note = const <String, dynamic>{}]) async {
  return Navigator.of(context).push(
      MaterialPageRoute<Map<String, dynamic>>(builder: (BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: note['content']);
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
          Navigator.of(context)
              .pop(<String, dynamic>{'content': _controller.text});
        },
      ),
    );
  }));
}
