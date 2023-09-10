import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_couch/bloc/chat_bloc.dart';
import 'package:motivation_couch/openai_service.dart';
import 'package:motivation_couch/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late ChatBloc _chatBloc;
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(OpenAIService());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatBloc,
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.status == ChatStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Motivation Couch'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.blueGrey.shade900,
            ),
            body: Column(
              children: [
                Expanded(child: _buildMessageList(state)),
                _buildInputField(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageList(ChatState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              return ChatMessage(message: state.messages[index]);
            },
          ),
        ),
        if (state.status == ChatStatus.loading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        if (state.status == ChatStatus.error)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(state.errorMessage ?? 'An error occurred'),
          ),
      ],
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

  void _sendMessage() {
    final text = _textController.text;
    if (text.isNotEmpty) {
      _chatBloc.add(SendMessage(text));
      _textController.clear();
    }
  }
}

class Message extends Equatable {
  final String text;
  final bool isUser;

  const Message({required this.text, this.isUser = false});

  @override
  List<Object?> get props => [text, isUser];
}
