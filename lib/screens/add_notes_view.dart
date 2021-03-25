import 'package:flutter/material.dart';
import 'package:notes/blocs/notes_bloc.dart';
import 'package:notes/screens/tab_view.dart';

class AddNotes extends StatefulWidget {
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final _formkey = GlobalKey<FormState>();

  Map<String, String> _note = {
    'title': '',
    'description': '',
  };
  bool _submiting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  onSaved: (newValue) {
                    _note["title"] = newValue;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter title";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: "Title",
                    contentPadding: EdgeInsets.all(18),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: Colors.black54,
                            width: 2,
                            style: BorderStyle.solid)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                IntrinsicHeight(
                  child: TextFormField(
                    onSaved: (newValue) {
                      _note["description"] = newValue;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter description";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.newline,
                    minLines: 10,
                    maxLines: 13,
                    decoration: InputDecoration(
                      hintText: "Description",
                      contentPadding: EdgeInsets.all(18),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2,
                              style: BorderStyle.solid)),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black)),
                        padding: EdgeInsets.symmetric(vertical: 15)),
                    child: _submiting
                        ? CircularProgressIndicator()
                        : Text(
                            "ADD",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                    onPressed: _submiting
                        ? null
                        : () {
                            if (_formkey.currentState.validate()) {
                              _formkey.currentState.save();
                              try {
                                setState(() {
                                  _submiting = true;
                                });
                                NotesBloc().postNotes(_note).then((value) {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => TabView(),
                                  ));
                                  setState(() {
                                    _submiting = false;
                                  });
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Somthing went wrong!"),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                setState(() {
                                  _submiting = false;
                                });
                              }
                            }
                          },
                  ),
                ),
              ],
            )),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
