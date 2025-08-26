import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';

part 'breathing_event.dart';
part 'breathing_state.dart';

class BreathingBloc extends Bloc<BreathingEvent, BreathingState> {
  final FlutterTts tts;
  Timer? _timer;

  BreathingBloc({required this.tts})
      : super(const BreathingState(
    instruction: "Press Start",
    isBreathing: false,
    timer: 0,
  )) {
    on<StartBreathingEvent>(_onStartBreathing);
    on<_UpdateTimerEvent>(_onUpdateTimer);
    on<_StopBreathingEvent>(_onStopBreathing);
  }

  Future<void> _onStartBreathing(
      StartBreathingEvent event, Emitter<BreathingState> emit) async {
    if (state.isBreathing) return;

    emit(state.copyWith(isBreathing: true));

    // --- Inhale ---
    emit(state.copyWith(instruction: "Breathe in positivity 🌸", timer: 4));
    await tts.speak("Breathe in");
    await _countdown(4, emit);

    // --- Hold ---
    emit(state.copyWith(instruction: "Hold Breath", timer: 6));
    await tts.speak("Hold");
    await Future.delayed(const Duration(seconds: 6));

    // --- Exhale ---
    emit(state.copyWith(instruction: "Breathe out negativity 💨", timer: 6));
    await tts.speak("Breathe out");
    await _countdown(6, emit);

    add(_StopBreathingEvent());
  }

  Future<void> _countdown(int seconds, Emitter<BreathingState> emit) async {
    for (int i = seconds; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      add(_UpdateTimerEvent(i - 1));
    }
  }

  void _onUpdateTimer(_UpdateTimerEvent event, Emitter<BreathingState> emit) {
    emit(state.copyWith(timer: event.time));
  }

  void _onStopBreathing(_StopBreathingEvent event, Emitter<BreathingState> emit) {
    emit(state.copyWith(
      instruction: "Great job! 🎉 You’re relaxed now.",
      isBreathing: false,
      timer: 0,
    ));
    tts.speak("Great job! You’re relaxed now");
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    tts.stop();
    return super.close();
  }
}
