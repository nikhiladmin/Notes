import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:notes/blocs/notes_bloc.dart';
import 'package:notes/models/Note.dart';
import 'note_detail_view.dart';

class NotesListView extends StatefulWidget {
  @override
  _NotesListViewState createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  NotesBloc _notesBloc = NotesBloc();

  @override
  void initState() {
    _notesBloc.eventSink.add(NotesEventType.GetList);
    super.initState();
  }

  @override
  void dispose() {
    _notesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Notes"),
      ),
      body: StreamBuilder<List<Note>>(
          stream: _notesBloc.notesStream,
          builder: (context, snapshot) {
            print(snapshot.hasError);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Somthing went wrong!"),
                behavior: SnackBarBehavior.floating,
              ));
            }
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) => OpenContainer(
                        closedElevation: 0,
                        closedBuilder: (context, action) => ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NoteDetails(
                                noteId: snapshot.data[index].id,
                              ),
                            ));
                          },
                          title: Text(snapshot.data[index].title),
                        ),
                        openBuilder: (context, action) => NoteDetails(),
                      ),
                  // itemBuilder: (context, index) => ListTile(
                  //       onTap: () {
                  //         Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => NoteDetails(),
                  //         ));
                  //       },
                  //       title: Text("Hello"),
                  //     ),
                  separatorBuilder: (context, index) => Divider(
                        height: 0,
                      ),
                  itemCount: snapshot.data.length);
            } else {
              return Center(child: Text("Add Notes"));
            }
          }),
    );
  }
}
