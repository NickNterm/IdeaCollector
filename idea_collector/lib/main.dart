import 'package:flutter/material.dart';
import 'package:idea_collector/Screens/MainScreen/MainScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idea Collector',
      theme: ThemeData(
        fontFamily: "Ubuntu",
        primarySwatch: Colors.teal,
      ),
      home: const MainScreen(),
    );
  }
}
