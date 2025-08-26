import 'package:flutter/material.dart';
import 'package:teen_depression/presentation/screens/exerciseSliderScreen.dart';
import 'package:teen_depression/presentation/screens/treeOfPositivity.dart';
import 'emojiPlayGround.dart';
import 'moodChatScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Soothing gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFCF7EC), Color(0xffE8EAF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🌟 Header Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Image.asset("assets/dragon.png", height: 80),
                    const SizedBox(height: 10),
                    const Text(
                      "Move & Mood",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.deepPurple,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // 🌸 Start Your Day Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xfffdfbfb), Color(0xffe6e0f8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Start Your Day",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Quick exercises\nthat lift your mood 🌞",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      Image.asset("assets/person.png", height: 110),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 🌟 Grid Buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildCard(Icons.chat_bubble_rounded, "Chat", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => MoodChatScreen()));
                      }),
                      _buildCard(Icons.self_improvement, "Exercise", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ExerciseSliderScreen()));
                      }),
                      _buildCard(Icons.emoji_emotions_rounded, "Emojis", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => EmojiPlayground()));
                      }),
                      _buildCard(Icons.energy_savings_leaf, "Positivity Tree", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TreeOfPositivityScreen()));
                      }),
                    ],
                  ),
                ),
              ),

              // 🌈 Bottom Affirmation
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xfff3e5f5), Color(0xffd1c4e9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Text(
                    "You are stronger than you think.\nTake a deep breath — you’re doing amazing.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurple,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Function onPressed) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xfff3f0ff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepPurple.shade50,
              child: Icon(icon, size: 32, color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
