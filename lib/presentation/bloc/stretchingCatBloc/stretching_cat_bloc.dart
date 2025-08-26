import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:teen_depression/presentation/bloc/stretchingCatBloc/stretching_cat_event.dart';
import 'package:teen_depression/presentation/bloc/stretchingCatBloc/stretching_cat_state.dart';

/// BLOC
class StretchBloc extends Bloc<StretchEvent, StretchState> {
  final FlutterTts _flutterTts = FlutterTts();

  StretchBloc() : super(const StretchInitial()) {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.setPitch(1.1);

    on<StartStretch>(_onStartStretch);
  }

  Future<void> _onStartStretch(
      StartStretch event, Emitter<StretchState> emit) async {
    if (state.isPlaying) return;

    emit(const StretchInProgress("Get Ready..."));

    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(seconds: 5));
      await _flutterTts.speak(i.toString());
      emit(StretchInProgress("Stretch $i"));
    }

    emit(const StretchDone());
  }

  @override
  Future<void> close() {
    _flutterTts.stop();
    return super.close();
  }
}