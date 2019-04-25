import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc.dart';

String _notesPreferencesKey = 'notes';

class NoteManagerBloc extends BlocBase {
  NoteManagerBloc() {
    _initSavedNotes();
    _initListeners();
  }

  final BehaviorSubject<List<String>> _notesController = BehaviorSubject<List<String>>();
  Stream<List<String>> get outNotes => _notesController.stream;

  final PublishSubject<String> _addNotesController = PublishSubject<String>();
  Sink<String> get inAddNotes => _addNotesController.sink;

  final PublishSubject<String> _removeNotesController = PublishSubject<String>();
  Sink<String> get inRmNotes => _removeNotesController.sink;

  @override
  void dispose() {
    // ! Closes all streams
    _notesController.close();
    _addNotesController.close();
    _removeNotesController.close();
  }

  void _initSavedNotes() {
    SharedPreferences.getInstance().then((SharedPreferences preferences) {
      final List<String> savedNotes = preferences.getStringList(_notesPreferencesKey) ?? <String>[];
      _notesController.sink.add(savedNotes);
    });
  }

  void _initListeners() {
    _addNotesController.stream.listen(_addNote);
    _removeNotesController.stream.listen(_rmNote);
    _notesController.stream.listen(_saveNotes);
  }

  void _addNote(String noteToAdd) {
    final List<String> actualData = List<String>.from(_notesController.value);
    actualData.add(noteToAdd);
    _notesController.sink.add(actualData);
  }

  void _rmNote(String noteToRm) {
    final List<String> actualData = List<String>.from(_notesController.value);
    actualData.remove(noteToRm);
    _notesController.sink.add(actualData);
  }

  void _saveNotes(List<String> notesToSave) {
    SharedPreferences.getInstance().then((SharedPreferences preferences) {
      preferences.setStringList(_notesPreferencesKey, notesToSave);
    });
  }
}
