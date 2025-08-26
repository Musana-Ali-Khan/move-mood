// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
//
// class MoodChatScreen extends StatefulWidget {
//   const MoodChatScreen({Key? key}) : super(key: key);
//
//   @override
//   _MoodChatScreenState createState() => _MoodChatScreenState();
// }
//
// class _MoodChatScreenState extends State<MoodChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = []; // {role: "user/ai", text: "msg"}
//   late GenerativeModel _model;
//   late ChatSession _chat;
//
//   @override
//   void initState() {
//     super.initState();
//     _model = GenerativeModel(
//       model: "gemini-pro",
//       apiKey: "YOUR_API_KEY", // <-- Replace with your Gemini API key
//     );
//     _chat = _model.startChat(history: [
//       Content.text(
//           "You are a supportive and cheerful best friend. Your job is to uplift mood, spread positivity, and make casual fun conversation. Reply warmly and casually, like chatting with your buddy."),
//     ]);
//   }
//
//   Future<void> _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//
//     setState(() {
//       _messages.add({"role": "user", "text": text});
//       _controller.clear();
//     });
//
//     final response = await _chat.sendMessage(Content.text(text));
//     final reply = response.text ?? "🙂 I'm here for you, buddy!";
//
//     setState(() {
//       _messages.add({"role": "ai", "text": reply});
//     });
//   }
//
//   // Detect clickable links
//   List<TextSpan> _parseText(String text, {bool isUser = false}) {
//     final regex = RegExp(r'(https?:\/\/[^\s]+)');
//     final matches = regex.allMatches(text);
//
//     if (matches.isEmpty) {
//       return [TextSpan(text: text)];
//     }
//
//     final spans = <TextSpan>[];
//     int lastIndex = 0;
//
//     for (final match in matches) {
//       final url = match.group(0)!;
//       if (match.start > lastIndex) {
//         spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
//       }
//       spans.add(
//         TextSpan(
//           text: url,
//           style: TextStyle(
//             color: isUser ? Colors.yellow.shade200 : Colors.deepPurple,
//             decoration: TextDecoration.underline,
//           ),
//           recognizer: TapGestureRecognizer()
//             ..onTap = () async {
//               final uri = Uri.parse(url);
//               if (await canLaunchUrl(uri)) {
//                 await launchUrl(uri, mode: LaunchMode.externalApplication);
//               }
//             },
//         ),
//       );
//       lastIndex = match.end;
//     }
//
//     if (lastIndex < text.length) {
//       spans.add(TextSpan(text: text.substring(lastIndex)));
//     }
//
//     return spans;
//   }
//
//   Widget _buildMessage(Map<String, String> msg) {
//     final isUser = msg["role"] == "user";
//     final text = msg["text"] ?? "";
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment:
//       isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         if (!isUser)
//           CircleAvatar(
//             backgroundColor: Colors.deepPurple,
//             child: const Text("F", style: TextStyle(color: Colors.white)),
//           ),
//         const SizedBox(width: 8),
//         Flexible(
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: isUser ? Colors.deepPurple : Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 4,
//                   color: Colors.black.withOpacity(0.1),
//                 )
//               ],
//             ),
//             child: SelectableText.rich(
//               TextSpan(
//                 children: _parseText(text, isUser: isUser),
//                 style: TextStyle(
//                   color: isUser ? Colors.white : Colors.black87,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (isUser)
//           const SizedBox(width: 8),
//         if (isUser)
//           CircleAvatar(
//             backgroundColor: Colors.deepPurple.shade200,
//             child: const Text("You", style: TextStyle(fontSize: 10)),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("Friend Chat 💜",
//         style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) => _buildMessage(_messages[index]),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     textInputAction: TextInputAction.send,
//                     onSubmitted: (_) => _sendMessage(),
//                     decoration: const InputDecoration(
//                       hintText: "Say something uplifting...",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.deepPurple),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../bloc/chatBloc/chat_bloc.dart';


class MoodChatScreen extends StatelessWidget {
   MoodChatScreen({Key? key}) : super(key: key);

  List<TextSpan> _parseText(String text, {bool isUser = false}) {
    final regex = RegExp(r'(https?:\/\/[^\s]+)');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) return [TextSpan(text: text)];

    final spans = <TextSpan>[];
    int lastIndex = 0;

    for (final match in matches) {
      final url = match.group(0)!;
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      spans.add(
        TextSpan(
          text: url,
          style: TextStyle(
            color: isUser ? Colors.yellow.shade200 : Colors.deepPurple,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
        ),
      );
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg["role"] == "user";
    final text = msg["text"] ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser)
          CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: const Text("F", style: TextStyle(color: Colors.white)),
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Colors.deepPurple : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            child: SelectableText.rich(
              TextSpan(
                children: _parseText(text, isUser: isUser),
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        if (isUser) const SizedBox(width: 8),
        if (isUser)
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade200,
            child: const Text("You", style: TextStyle(fontSize: 10)),
          ),
      ],
    );
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Friend Chat 💜", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  _scrollToBottom();
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) => _buildMessage(state.messages[index]),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        final text = controller.text.trim();
                        if (text.isNotEmpty) {
                          context.read<ChatBloc>().add(SendMessageEvent(text));
                          controller.clear();
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Say something uplifting...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isNotEmpty) {
                        context.read<ChatBloc>().add(SendMessageEvent(text));
                        controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
