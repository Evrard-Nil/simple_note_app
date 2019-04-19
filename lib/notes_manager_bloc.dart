import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc.dart';

String _notesPreferencesKey = const Key('notes').hashCode.toString();

class NoteManagerBloc extends BlocBase {
  factory NoteManagerBloc() {
    return _singleton;
  }

  NoteManagerBloc._internal() {
    _initSavedNotes();
    _initListeners();
  }

  static final NoteManagerBloc _singleton = NoteManagerBloc._internal();

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
    _notesController.stream.listen((List<String> onData) {
      List<String> notes = List<String>.from(onData ?? <String>[]);
      notes.add(noteToAdd);
      _notesController.sink.add(notes);
    });
  }

  void _rmNote(String noteToRm) {
    _notesController.stream.listen((onData) {
      List<String> notes = List<String>.from(onData);
      notes.add(noteToRm);
      _notesController.sink.add(notes);
    });
  }

  void _saveNotes(List<String> notesToSave) {
    SharedPreferences.getInstance().then((SharedPreferences preferences) {
      preferences.setStringList(_notesPreferencesKey, notesToSave);
    });
  }
}
