import 'package:flutter/material.dart';
import 'package:motivation_couch/chat_screen.dart';

void main() => runApp(const MotivationCouchApp());

class MotivationCouchApp extends StatelessWidget {
  const MotivationCouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivation Couch',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.lightBlueAccent,
      ),
      home: const ChatScreen(),
    );
  }
}
