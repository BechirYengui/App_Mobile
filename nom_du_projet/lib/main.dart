// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

import 'welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freelansi',
      theme: ThemeData(
        primaryColor: Color(0xFF284E7B),
        scaffoldBackgroundColor: Color(0xFFADD4F3),
      ),
      home: Welcome(),
    );
  }
}
