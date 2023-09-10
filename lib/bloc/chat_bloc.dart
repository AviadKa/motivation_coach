import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_couch/chat_screen.dart';
import 'package:motivation_couch/openai_service.dart';

// Events
abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String text;

  SendMessage(this.text);
}

// States
enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<Message> messages;
  final String? errorMessage;

  const ChatState({
    required this.status,
    this.messages = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, messages, errorMessage];
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final OpenAIService openAIService;

  ChatBloc(this.openAIService) : super(const ChatState(status: ChatStatus.initial));

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SendMessage) {
      yield ChatState(
        status: ChatStatus.loading,
        messages: [
          ...state.messages,
          Message(text: event.text, isUser: true),
        ],
      );

      try {
        final chatGPTResponse = await openAIService.getResponse(prompt: event.text);
        yield ChatState(status: ChatStatus.loaded, messages: [
          ...state.messages,
          Message(text: chatGPTResponse, isUser: false),
        ]);
      } catch (error) {
        yield ChatState(
            status: ChatStatus.error, messages: state.messages, errorMessage: 'Failed to fetch response from OpenAI');
      }
    }
  }
}
