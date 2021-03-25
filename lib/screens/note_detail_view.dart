import 'package:flutter/material.dart';
import 'package:notes/blocs/note_detail_bloc.dart';
import 'package:notes/models/Note.dart';
import 'package:notes/screens/tab_view.dart';

class NoteDetails extends StatefulWidget {
  final String noteId;

  const NoteDetails({Key key, this.noteId}) : super(key: key);
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  NoteDetailsBloc _noteDetailsBloc = NoteDetailsBloc();
  bool _deleting = false;

  @override
  void initState() {
    _noteDetailsBloc.getNoteDetails(widget.noteId);
    super.initState();
  }

  @override
  void dispose() {
    _noteDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<Note>(
              stream: _noteDetailsBloc.noteDetailsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        snapshot.data.title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 30,
                      ),
                      Text(
                        snapshot.data.description,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      )
                    ],
                  );
                } else {
                  return Text("helo");
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: !_deleting
            ? Icon(Icons.delete)
            : CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
        onPressed: !_deleting
            ? () {
                if (mounted)
                  setState(() {
                    _deleting = true;
                  });
                _noteDetailsBloc.deleteNote(widget.noteId).then((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => TabView(),
                      ),
                      (route) => false);
                });
              }
            : null,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
