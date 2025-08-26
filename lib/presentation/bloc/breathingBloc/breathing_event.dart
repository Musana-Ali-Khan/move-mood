part of 'breathing_bloc.dart';

abstract class BreathingEvent extends Equatable {
  const BreathingEvent();

  @override
  List<Object?> get props => [];
}

class StartBreathingEvent extends BreathingEvent {}

class _UpdateTimerEvent extends BreathingEvent {
  final int time;
  const _UpdateTimerEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class _StopBreathingEvent extends BreathingEvent {}
