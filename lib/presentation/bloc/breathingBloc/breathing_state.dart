part of 'breathing_bloc.dart';

class BreathingState extends Equatable {
  final String instruction;
  final bool isBreathing;
  final int timer;

  const BreathingState({
    required this.instruction,
    required this.isBreathing,
    required this.timer,
  });

  BreathingState copyWith({
    String? instruction,
    bool? isBreathing,
    int? timer,
  }) {
    return BreathingState(
      instruction: instruction ?? this.instruction,
      isBreathing: isBreathing ?? this.isBreathing,
      timer: timer ?? this.timer,
    );
  }

  @override
  List<Object?> get props => [instruction, isBreathing, timer];
}
