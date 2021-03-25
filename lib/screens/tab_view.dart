import 'package:flutter/material.dart';
import './add_notes_view.dart';
import 'notes_view.dart';
import './trash_view.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _pageSelected = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  List<Widget> _tabs = [
    NotesListView(),
    AddNotes(),
    TrashView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_pageSelected],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey[400], blurRadius: 3)],
        ),
        child: BottomNavigationBar(
          onTap: _pageSelector,
          unselectedItemColor: Colors.grey,
          currentIndex: _pageSelected,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: "Notes",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.note_add,
                color: Colors.purple,
              ),
              label: "Add",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: "Trash",
            ),
          ],
        ),
      ),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _pageSelected = index;
    });
  }

  void _pageSelector(int value) {
    if (value == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddNotes(),
      ));
    } else {
      setState(() {
        _pageSelected = value;
      });
    }
  }
}
