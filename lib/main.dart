import 'package:flutter/material.dart';

import './screens/tab_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.dark),
        primarySwatch: Colors.deepPurple,
      ),
      home: TabView(),
    );
  }
}
