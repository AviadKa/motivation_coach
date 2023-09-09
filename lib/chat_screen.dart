import 'package:flutter/material.dart';
import 'package:motivation_couch/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation Couch'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatMessage(text: messages[index], isUser: true);
      },
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
        border: Border(
          top: BorderSide(color: Colors.blueGrey.shade500, width: 2.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(color: Colors.blueGrey.shade300),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.lightBlueAccent),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                setState(() {
                  messages.add(_textController.text);
                });
                _textController.clear();
                // TODO: Send the message to ChatGPT
              }
            },
          ),
        ],
      ),
    );
  }
}
