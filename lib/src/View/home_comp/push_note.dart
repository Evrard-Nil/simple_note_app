import 'package:flutter/material.dart';

Future<String> pushNote(BuildContext context, [String note = '']) async {
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
