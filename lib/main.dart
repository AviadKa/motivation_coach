import 'package:flutter/material.dart';
import 'package:motivation_couch/chat_screen.dart';

void main() => runApp(MotivationCouchApp());

class MotivationCouchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivation Couch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}