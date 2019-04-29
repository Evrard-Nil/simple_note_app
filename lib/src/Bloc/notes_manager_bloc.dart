import 'dart:async';

import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'bloc.dart';

String dbPath = 'notesdb';

class NoteManagerBloc extends BlocBase {
  NoteManagerBloc() {
    _initSavedNotes();
    _initListeners();
  }

  final BehaviorSubject<List<Map<String, dynamic>>> _notesController =
      BehaviorSubject<List<Map<String, dynamic>>>();
  Stream<List<Map<String, dynamic>>> get outNotes => _notesController.stream;

  final PublishSubject<Map<String, dynamic>> _addNotesController =
      PublishSubject<Map<String, dynamic>>();
  Sink<Map<String, dynamic>> get inAddNotes => _addNotesController.sink;

  final PublishSubject<Map<String, dynamic>> _removeNotesController =
      PublishSubject<Map<String, dynamic>>();
  Sink<Map<String, dynamic>> get inRmNotes => _removeNotesController.sink;

  String path;
  Database db;

  @override
  void dispose() {
    // ! Closes all streams
    _notesController.close();
    _addNotesController.close();
    _removeNotesController.close();
  }

  Future<void> _initSavedNotes() async {
    path = join(await getDatabasesPath(), dbPath);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db
          .execute('CREATE TABLE Notes (id INTEGER PRIMARY KEY, content TEXT)');
      _notesController.sink.add(<Map<String, dynamic>>[]);
    }, onOpen: (Database db) async {
      final List<Map<String, dynamic>> notes =
          await db.rawQuery('SELECT * from Notes');
      _notesController.sink.add(notes);
    });
  }

  void _initListeners() {
    _addNotesController.stream.listen(_addNote);
    _removeNotesController.stream.listen(_rmNote);
  }

  void _addNote(Map<String, dynamic> noteToAdd) {
    db.rawInsert(
        'INSERT INTO Notes(content) VALUES ("' + noteToAdd['content'] + '")');
    final List<Map<String, dynamic>> actualData =
        List<Map<String, dynamic>>.from(
            _notesController.value ?? <Map<String, dynamic>>[]);
    actualData.add(noteToAdd);
    _notesController.sink.add(actualData);
  }

  void _rmNote(Map<String, dynamic> noteToRm) {
    db.rawDelete(
        'DELETE FROM Notes WHERE content = ?', <String>[noteToRm['content']]);
    final List<Map<String, dynamic>> actualData =
        List<Map<String, dynamic>>.from(
            _notesController.value ?? <Map<String, dynamic>>[]);
    actualData.remove(noteToRm);
    _notesController.sink.add(actualData);
  }
}
