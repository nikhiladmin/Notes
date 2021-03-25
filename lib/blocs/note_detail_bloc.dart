import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/config/Strings.dart';
import 'package:notes/models/Note.dart';

enum NoteDetailsEventType { Fetch, Delete }

class NoteDetailsBloc {
  final _stateStreamController = StreamController<Note>();

  StreamSink<Note> get _noteDetailsSink => _stateStreamController.sink;
  Stream<Note> get noteDetailsStream => _stateStreamController.stream;

  void dispose() {
    _stateStreamController.close();
  }

  Future<void> getNoteDetails(String id) async {
    final response = json.decode(
        (await http.get(Uri.parse(Strings.baseURL + "notes/" + id + ".json")))
            .body);
    Note _note = Note(
        id: id, title: response["title"], description: response["description"]);

    if (!_stateStreamController.isClosed) _noteDetailsSink.add(_note);
  }

  Future<void> deleteNote(
    String id,
  ) async {
    final getResponse =
        (await http.get(Uri.parse(Strings.baseURL + "notes/" + id + ".json")))
            .body;

    await http.post(Uri.parse(Strings.baseURL + "trash.json"),
        body: getResponse);

    await http.delete(Uri.parse(Strings.baseURL + "notes/" + id + ".json"));
  }
}
