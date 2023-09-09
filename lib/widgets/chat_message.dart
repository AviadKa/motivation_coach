import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isUser ? _userMessage(context) : _chatGPTMessage(context),
      ),
    );
  }

  List<Widget> _userMessage(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Bubble(
                color: Theme.of(context).accentColor,
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
      const Icon(Icons.account_circle, size: 40.0, color: Colors.lightBlueAccent),
    ];
  }

  List<Widget> _chatGPTMessage(BuildContext context) {
    // We'll fill this in later when we integrate with ChatGPT
    return <Widget>[];
  }
}