import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GenerativeModel model;
  late final ChatSession _chat;

  ChatBloc(this.model) : super(const ChatState()) {
    _chat = model.startChat(history: [
      Content.text(
          "You are a supportive and cheerful best friend. Your job is to uplift mood, spread positivity, and make casual fun conversation. Reply warmly and casually, like chatting with your buddy."),
    ]);

    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    // Add user message immediately
    final updatedMessages = List<Map<String, String>>.from(state.messages)
      ..add({"role": "user", "text": event.message});
    emit(state.copyWith(messages: updatedMessages));

    // Get reply
    final response = await _chat.sendMessage(Content.text(event.message));
    final reply = response.text ?? "🙂 I'm here for you, buddy!";

    final newMessages = List<Map<String, String>>.from(updatedMessages)
      ..add({"role": "ai", "text": reply});
    emit(state.copyWith(messages: newMessages));
  }
}
