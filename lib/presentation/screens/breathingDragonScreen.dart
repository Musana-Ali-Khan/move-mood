import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../bloc/breathingBloc/breathing_bloc.dart';

class BreathingDragonScreen extends StatefulWidget {
  const BreathingDragonScreen({Key? key}) : super(key: key);

  @override
  State<BreathingDragonScreen> createState() => _BreathingDragonScreenState();
}

class _BreathingDragonScreenState extends State<BreathingDragonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 19),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade700,
      body: SafeArea(
        child: BlocBuilder<BreathingBloc, BreathingState>(
          builder: (context, state) {
            if (state.isBreathing) {
              _animController.repeat(reverse: false);
            } else {
              _animController.stop();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Breathing Dragon",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Breathe in positivity... Hold... Exhale negativity",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (_, child) {
                          final value = state.isBreathing
                              ? (0.5 + 0.5 * _animController.value)
                              : 0.5;
                          return Container(
                            width: 200 * value,
                            height: 200 * value,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade300
                                  .withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                      Image.asset("assets/dragon.png", width: 150),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  state.instruction +
                      (state.timer > 0 ? " (${state.timer})" : ""),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (!state.isBreathing) {
                      context.read<BreathingBloc>().add(StartBreathingEvent());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    state.isBreathing ? "Breathing..." : "Start",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
