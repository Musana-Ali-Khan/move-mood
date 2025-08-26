// chat_state.dart
part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Map<String, String>> messages;

  const ChatState({this.messages = const []});

  ChatState copyWith({List<Map<String, String>>? messages}) {
    return ChatState(messages: messages ?? this.messages);
  }

  @override
  List<Object?> get props => [messages];
}
