// stretch_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// EVENTS
abstract class StretchEvent {}

class StartStretch extends StretchEvent {}