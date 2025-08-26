/// STATES
abstract class StretchState {
  final bool isPlaying;
  final String status;
  const StretchState({required this.isPlaying, required this.status});
}

class StretchInitial extends StretchState {
  const StretchInitial() : super(isPlaying: false, status: "Press Start");
}

class StretchInProgress extends StretchState {
  const StretchInProgress(String status)
      : super(isPlaying: true, status: status);
}

class StretchDone extends StretchState {
  const StretchDone()
      : super(isPlaying: false, status: "Done 🎉 Great Job!");
}