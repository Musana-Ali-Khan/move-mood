import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:teen_depression/presentation/bloc/breathingBloc/breathing_bloc.dart';
import 'package:teen_depression/presentation/bloc/chatBloc/chat_bloc.dart';
import 'package:teen_depression/presentation/bloc/stretchingCatBloc/stretching_cat_bloc.dart';
import 'package:teen_depression/presentation/screens/homeScreen.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => ChatBloc(
          GenerativeModel(
            model: "gemini-2.0-flash",
            apiKey: "YOUR_API_KEY", // <-- Replace with Gemini API key
          ),
        ),
      ),
      BlocProvider(
        create: (_) => StretchBloc(),
      ),
      BlocProvider(
        create: (_) => BreathingBloc(tts: FlutterTts()
        ..setLanguage("en-US")
        ..setSpeechRate(0.4)
        ..setPitch(1.0)),),

    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Move & Mood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  HomeScreen(),
    );
  }
}

