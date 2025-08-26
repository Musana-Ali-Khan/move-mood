import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stretchingCatBloc/stretching_cat_bloc.dart';
import '../bloc/stretchingCatBloc/stretching_cat_event.dart';
import '../bloc/stretchingCatBloc/stretching_cat_state.dart';

class StretchCatScreen extends StatefulWidget {
  const StretchCatScreen({Key? key}) : super(key: key);

  @override
  State<StretchCatScreen> createState() => _StretchCatScreenState();
}

class _StretchCatScreenState extends State<StretchCatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 1.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7EC),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                "Stretch like a cat",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                "Do 3 stretches",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Cat Image with animation
              ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/cat.png",
                    height: 200,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Status
              BlocBuilder<StretchBloc, StretchState>(
                builder: (context, state) {
                  return Text(
                    state.status,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.brown,
                    ),
                  );
                },
              ),

              const SizedBox(height: 50),

              // Button
              BlocBuilder<StretchBloc, StretchState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isPlaying
                        ? null
                        : () {
                      context
                          .read<StretchBloc>()
                          .add(StartStretch());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      state.isPlaying ? "Stretching..." : "Start",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
