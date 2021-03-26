import 'package:flutter/material.dart';
import 'package:notes/blocs/notes_bloc.dart';
import 'package:notes/models/Note.dart';
import './note_detail_view.dart';

class TrashView extends StatefulWidget {
  @override
  _TrashViewState createState() => _TrashViewState();
}

class _TrashViewState extends State<TrashView> {
  NotesBloc _notesBloc = NotesBloc();
  List<Note> trash = [];
  @override
  void initState() {
    super.initState();
  }

  bool _loading = false;
  bool _restoring = false;
  @override
  didChangeDependencies() async {
    setState(() {
      _loading = true;
    });
    try {
      trash.addAll(await _notesBloc.getNotesTrash());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Somthing went wrong!"),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            label: "RETRY",
            onPressed: () async {
              trash.addAll(await _notesBloc.getNotesTrash());
            }),
      ));
    }
    setState(() {
      _loading = false;
    });
    super.didChangeDependencies();
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
        title: Text("Trash"),
        actions: [
          Container(
            padding: EdgeInsets.all(20),
            width: 55,
            child: !_restoring
                ? SizedBox()
                : CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2,
                  ),
          )
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : trash.length == 0
              ? Center(child: Text("Trash Empty"))
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        trailing: IconButton(
                          icon: Icon(
                            Icons.restore_from_trash,
                            color: Colors.black,
                          ),
                          onPressed: _restoring
                              ? null
                              : () {
                                  setState(() {
                                    _restoring = true;
                                  });
                                  _notesBloc
                                      .restoreNote(trash[index].id)
                                      .then((value) {
                                    if (mounted)
                                      setState(() {
                                        trash.removeAt(index);
                                        _restoring = false;
                                      });
                                  });
                                },
                        ),
                        title: Text(trash[index].title),
                      ),
                  separatorBuilder: (context, index) => Divider(
                        height: 0,
                      ),
                  itemCount: trash.length),
    );
  }
}
