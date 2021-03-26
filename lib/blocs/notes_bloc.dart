import 'dart:async';
import 'dart:convert';
import 'package:notes/config/Strings.dart';
import 'package:notes/models/Note.dart';
import 'package:http/http.dart' as http;

enum NotesEventType { GetList, GetTrash }

class NotesBloc {
  final _stateStreamController = StreamController<List<Note>>();
  StreamSink<List<Note>> get _notesSink => _stateStreamController.sink;
  Stream<List<Note>> get notesStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NotesEventType>();
  StreamSink<NotesEventType> get eventSink => _eventStreamController.sink;
  Stream<NotesEventType> get _eventStream => _eventStreamController.stream;

  void dispose() {
    _stateStreamController?.close();
    _eventStreamController?.close();
  }

  NotesBloc() {
    _eventStream.listen((event) async {
      if (event == NotesEventType.GetList) {
        List<Note> notes = await getNotes();
        if (!_eventStreamController.isClosed) _notesSink.add(notes);
      }
    });
  }

  Future<List<Note>> getNotes() async {
    List<Note> notes = [];
    try {
      final response =
          await http.get(Uri.parse(Strings.baseURL + "notes.json"));

      if (response.body != null) {
        final data = json.decode(response.body);
        data.forEach((key, value) {
          notes.add(Note(
              title: value['title'],
              description: value['description'],
              id: key));
        });
      }
      return notes;
    } catch (e) {
      _notesSink.addError("Something went Wrong!");
    }
  }

  Future<void> postNotes(Map<String, String> _notes) async {
    try {
      final response = await http.post(
          Uri.parse(Strings.baseURL + "notes.json"),
          body: json.encode(_notes));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Note>> getNotesTrash() async {
    List<Note> notes = [];

    final response = await http.get(Uri.parse(Strings.baseURL + "trash.json"));
    final data = json.decode(response.body);
    if (data != null) {
      data.forEach((key, value) {
        notes.add(Note(
            title: value['title'], description: value['description'], id: key));
      });
    }
    return notes;
  }

  Future<void> restoreNote(
    String id,
  ) async {
    try {
      final getResponse =
          (await http.get(Uri.parse(Strings.baseURL + "trash/" + id + ".json")))
              .body;

      await http.post(Uri.parse(Strings.baseURL + "notes.json"),
          body: getResponse);

      await http.delete(Uri.parse(Strings.baseURL + "trash/" + id + ".json"));
    } catch (e) {
      rethrow;
    }
  }
}
