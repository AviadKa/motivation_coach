import 'package:bloc_test/bloc_test.dart';
import 'package:motivation_couch/bloc/chat_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:motivation_couch/chat_screen.dart';
import 'package:motivation_couch/openai_service.dart';
import 'package:test/test.dart';

@GenerateMocks([OpenAIService])
import 'chat_bloc_test.mocks.dart';

void main() {
  group('ChatBloc', () {
    late MockOpenAIService mockOpenAIService;

    setUp(() {
      mockOpenAIService = MockOpenAIService();
    });

    // Test for successful message sending
    blocTest<ChatBloc, ChatState>(
      'emits [Loading, MessageSent] when SendMessage succeeds',
      build: () {
        when(mockOpenAIService.getResponse(prompt: captureAnyNamed('prompt')))
            .thenAnswer((_) async => Future.value('Test Response'));
        return ChatBloc(mockOpenAIService);
      },
      act: (bloc) => bloc.add(SendMessage('Test')),
      expect: () => [
        const ChatState(status: ChatStatus.loading, messages: [
          Message(text: 'Test', isUser: true),
        ]),
        const ChatState(status: ChatStatus.loaded, messages: [
          Message(text: 'Test', isUser: true),
          Message(text: 'Test Response', isUser: false),
        ])
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits [Loading, MessageError] when SendMessage fails',
      build: () {
        when(mockOpenAIService.getResponse(prompt: captureAnyNamed('prompt'))).thenThrow(Exception('API Error'));
        return ChatBloc(mockOpenAIService);
      },
      act: (bloc) => bloc.add(SendMessage('Test')),
      expect: () => [
        const ChatState(status: ChatStatus.loading, messages: [Message(text: 'Test', isUser: true)]),
        const ChatState(
          status: ChatStatus.error,
          errorMessage: 'Failed to fetch response from OpenAI',
          messages: [
            Message(text: 'Test', isUser: true),
          ],
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'does not emit any state when sending an empty message',
      build: () => ChatBloc(mockOpenAIService),
      act: (bloc) => bloc.add(SendMessage('')),
      expect: () => [
        const ChatState(status: ChatStatus.loading, messages: [Message(text: '', isUser: true)]),
        const ChatState(
          status: ChatStatus.error,
          errorMessage: 'Failed to fetch response from OpenAI',
          messages: [
            Message(text: '', isUser: true),
          ],
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>('emits states for multiple messages',
        build: () {
          when(mockOpenAIService.getResponse(prompt: captureAnyNamed('prompt')))
              .thenAnswer((_) async => 'Test Response');
          return ChatBloc(mockOpenAIService);
        },
        act: (bloc) {
          bloc
            ..add(SendMessage('Test 1'))
            ..add(SendMessage('Test 2'));
        },
        expect: () => [
              const ChatState(
                status: ChatStatus.loading,
                messages: [Message(text: 'Test 1', isUser: true)],
              ),
              const ChatState(
                  status: ChatStatus.loaded,
                  messages: [Message(text: 'Test 1', isUser: true), Message(text: 'Test Response', isUser: false)]),
              const ChatState(status: ChatStatus.loading, messages: [
                Message(text: 'Test 1', isUser: true),
                Message(text: 'Test Response', isUser: false),
                Message(text: 'Test 2', isUser: true)
              ]),
              const ChatState(status: ChatStatus.loaded, messages: [
                Message(text: 'Test 1', isUser: true),
                Message(text: 'Test Response', isUser: false),
                Message(text: 'Test 2', isUser: true),
                Message(text: 'Test Response', isUser: false),
              ])
            ]);

    blocTest<ChatBloc, ChatState>('retries after an error',
        build: () {
          int callCount = 0;
          when(mockOpenAIService.getResponse(prompt: captureAnyNamed('prompt'))).thenAnswer((_) {
            if (callCount == 0) {
              callCount++;
              throw Exception('API Error');
            } else {
              return Future.value('Test Response after retry');
            }
          });
          return ChatBloc(mockOpenAIService);
        },
        act: (bloc) {
          bloc
            ..add(SendMessage('Test'))
            ..add(SendMessage('Test')); // Retry
        },
        expect: () => [
              const ChatState(status: ChatStatus.loading, messages: [Message(text: 'Test', isUser: true)]),
              const ChatState(
                  status: ChatStatus.error,
                  messages: [Message(text: 'Test', isUser: true)],
                  errorMessage: 'Failed to fetch response from OpenAI'),
              const ChatState(
                  status: ChatStatus.loading,
                  messages: [Message(text: 'Test', isUser: true), Message(text: 'Test', isUser: true)]),
              const ChatState(status: ChatStatus.loaded, messages: [
                Message(text: 'Test', isUser: true),
                Message(text: 'Test', isUser: true),
                Message(text: 'Test Response after retry', isUser: false)
              ])
            ]);
  });
}
