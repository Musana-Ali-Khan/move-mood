import 'package:flutter/material.dart';
import 'package:teen_depression/presentation/screens/stretchingCat.dart';
import 'breathingDragonScreen.dart';

class ExerciseSliderScreen extends StatefulWidget {
  @override
  _ExerciseSliderScreenState createState() => _ExerciseSliderScreenState();
}

class _ExerciseSliderScreenState extends State<ExerciseSliderScreen> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  final List<Map<String, dynamic>> exercises = [
    {
      "title": "Stretch Like Cat",
      "color": Color(0xFFFCF7EC),
      "image": "assets/cat.png",
    },
    {
      "title": "Breathing Dragon",
      "color": Color(0xFFFCF7EC),
      "image": "assets/dragon.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        itemCount: exercises.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 150),
            child: GestureDetector(
              onTap: () {
                // 🔗 Navigate to actual exercise screen later
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Selected: ${exercise['title']}")),
                // );
                if(exercise['title'] == "Stretch Like Cat"){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>StretchCatScreen()));
                }else if(exercise['title'] == "Breathing Dragon"){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>BreathingDragonScreen()));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: exercise["color"],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Image.asset(
                          exercise["image"],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          exercise["title"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
