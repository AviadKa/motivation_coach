import 'package:flutter/material.dart';
import 'package:motivation_couch/openai_service.dart';
import 'package:motivation_couch/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;
  final _openAIService = OpenAIService();
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
      itemCount: messages.length + (_isLoading ? 1 : 0), // Add one more space for the loader
      itemBuilder: (context, index) {
        if (index < messages.length) {
          return ChatMessage(text: messages[index], isUser: true);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
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
              onSubmitted: (text) {
                _sendMessage();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.lightBlueAccent),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      final userMessage = _textController.text;
      setState(() {
        messages.add(userMessage);
        _isLoading = true; // Start loading
      });
      _textController.clear();

      try {
        final chatGPTResponse = await _openAIService.getResponse(userMessage);
        setState(() {
          messages.add(chatGPTResponse);
          _isLoading = false; // Stop loading
        });
      } catch (error) {
        setState(() {
          _isLoading = false; // Stop loading
        });
        // Handle the error in the next step
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to fetch response from OpenAI'),
            action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _sendMessage();
              },
            ),
          ),
        );
      }
    }
  }
}
