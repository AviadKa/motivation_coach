import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:motivation_couch/chat_screen.dart';

class ChatMessage extends StatelessWidget {
  final Message message;

  const ChatMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.isUser ? _userMessage(context) : _chatGPTMessage(context),
      ),
    );
  }

  List<Widget> _userMessage(BuildContext context) {
    return <Widget>[
      const Icon(Icons.account_circle, size: 40.0, color: Colors.lightBlueAccent),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Text(
                senderName,
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Bubble(
                color: Theme.of(context).accentColor,
                child: Text(message.text),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _chatGPTMessage(BuildContext context) {
    return <Widget>[
      const Icon(Icons.chat, size: 40.0, color: Colors.grey),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: Text(senderName, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Bubble(
                color: Colors.grey.shade800,
                child: Text(message.text),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  String get senderName => message.isUser ? "You" : "ChatGPT";
}
