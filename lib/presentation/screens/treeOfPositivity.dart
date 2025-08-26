import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tree of Positivity Screen
/// - Tap "Complete Activity" to earn a leaf (simulates finishing an exercise)
/// - Tap the tree to view stats and a random affirmation
/// - Tap leaf/flower/fruit to get a little affirmation popup
class TreeOfPositivityScreen extends StatefulWidget {
  const TreeOfPositivityScreen({Key? key}) : super(key: key);

  @override
  _TreeOfPositivityScreenState createState() => _TreeOfPositivityScreenState();
}

class _TreeOfPositivityScreenState extends State<TreeOfPositivityScreen>
    with TickerProviderStateMixin {
  // Progress counters
  int leaves = 0;
  int flowers = 0;
  int fruits = 0;

  // Streak tracking
  int streakDays = 0;
  DateTime? lastCompletedDate;

  // Animation controllers
  late AnimationController _leafAddController;
  late AnimationController _treePulseController;

  // Affirmations
  final List<String> _affirmations = [
    "Nice one — you're taking care of yourself 🌿",
    "Small steps matter. Proud of you.",
    "Breathe. You're doing great.",
    "One moment at a time — you're growing.",
    "You deserve kindness — especially from yourself.",
    "You're not alone. I'm with you.",
    "Healing takes time, and you are on the right path.",
    "Your feelings are valid. It's okay to rest.",
    "Every breath you take is a fresh start.",
    "You are worthy of peace and love.",
    "Even clouds make way for sunshine ☀️",
    "You are stronger than you think.",
    "It’s okay to slow down. You’re still moving forward.",
    "Your presence in this world matters.",
    "Today is a new chance to begin again.",
    "You are learning, and that’s enough.",
    "You bring light into the world — even if you can’t see it right now.",
    "Trust yourself. You are growing beautifully.",
    "Kindness starts with you — and you deserve it.",
    "You are brave for showing up today.",
    "Step by step, you’re building the life you deserve.",
    "Rest is productive too. 🌸",
    "Believe in your ability to heal.",
    "It’s okay to feel — you’re human, and that’s beautiful.",
  ];

  final Random _rnd = Random();

  // Persistence keys
  static const _kLeaves = "tree_leaves";
  static const _kFlowers = "tree_flowers";
  static const _kFruits = "tree_fruits";
  static const _kStreak = "tree_streak";
  static const _kLastDate = "tree_last_date"; // stored as yyyy-MM-dd

  @override
  void initState() {
    super.initState();
    _leafAddController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _treePulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.98,
      upperBound: 1.02,
    )..repeat(reverse: true);

    _loadProgress();
  }

  @override
  void dispose() {
    _leafAddController.dispose();
    _treePulseController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      leaves = prefs.getInt(_kLeaves) ?? 0;
      flowers = prefs.getInt(_kFlowers) ?? 0;
      fruits = prefs.getInt(_kFruits) ?? 0;
      streakDays = prefs.getInt(_kStreak) ?? 0;
      final last = prefs.getString(_kLastDate);
      lastCompletedDate = last == null ? null : DateTime.tryParse(last);
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLeaves, leaves);
    await prefs.setInt(_kFlowers, flowers);
    await prefs.setInt(_kFruits, fruits);
    await prefs.setInt(_kStreak, streakDays);
    await prefs.setString(_kLastDate,
        lastCompletedDate?.toIso8601String().split('T').first ?? '');
  }

  void _showAffirmation(String message) {
    final snack = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.deepPurple.shade600,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  String _randomAffirmation() =>
      _affirmations[_rnd.nextInt(_affirmations.length)];

  /// Called when user completes an activity
  Future<void> _completeActivity() async {
    // Award one leaf
    setState(() {
      leaves += 1;
    });

    // Play add animation
    _leafAddController.forward(from: 0.0);

    // Streak logic: if lastCompletedDate is yesterday -> increment streak
    final today = DateTime.now();
    final last = lastCompletedDate;
    if (last == null) {
      streakDays = 1;
    } else {
      final lastDateOnly =
      DateTime(last.year, last.month, last.day); // midnight
      final todayOnly = DateTime(today.year, today.month, today.day);
      final diff = todayOnly.difference(lastDateOnly).inDays;
      if (diff == 0) {
        // same day — do not increment streak
      } else if (diff == 1) {
        streakDays += 1;
      } else {
        streakDays = 1; // reset
      }
    }
    lastCompletedDate = today;

    // Give a flower for every 3-day streak
    if (streakDays > 0 && streakDays % 3 == 0) {
      flowers += 1;
      _showAffirmation(
          "Lovely — ${streakDays} day streak! You earned a 🌸 (flower).");
    }

    // Give a fruit every 10 leaves
    if (leaves % 10 == 0) {
      fruits += 1;
      _showAffirmation("Amazing! You unlocked a fruit 🍎 — keep going.");
    }

    // minor affirmation
    _showAffirmation(_randomAffirmation());

    await _saveProgress();
  }

  /// Reset progress (for demo/testing)
  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLeaves);
    await prefs.remove(_kFlowers);
    await prefs.remove(_kFruits);
    await prefs.remove(_kStreak);
    await prefs.remove(_kLastDate);
    setState(() {
      leaves = 0;
      flowers = 0;
      fruits = 0;
      streakDays = 0;
      lastCompletedDate = null;
    });
  }

  /// Build positioned widgets (leaves / flowers / fruits) across the tree area
  List<Widget> _buildTreeDecorations(BoxConstraints c) {
    final List<Widget> items = [];
    final areaW = c.maxWidth;
    final areaH = c.maxHeight;

    // helper to make random-ish positions but deterministic per index
    double xFor(int i) {
      final r = (i * 37) % 100 / 100;
      return r * (areaW - 50);
    }

    double yFor(int i, double base) {
      final r = ((i * 73 + 13) % 100) / 100;
      return base + r * (areaH * 0.45);
    }

    // leaves
    for (int i = 0; i < leaves; i++) {
      final left = xFor(i);
      final top = yFor(i, areaH * 0.05);
      final scale = 0.7 + ((i % 5) / 10);
      final appearDelay = Duration(milliseconds: 120 * (i % 6));
      items.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 700),
          left: left,
          top: top,
          width: 28 * scale,
          height: 28 * scale,
          child: FadeTransition(
            opacity: _leafAddController.drive(
              CurveTween(curve: Curves.easeInOut),
            ),
            child: GestureDetector(
              onTap: () => _showAffirmation(
                  "Leaf ${i + 1}: ${_randomAffirmation()}"),
              child: Transform.rotate(
                angle: (i % 2 == 0) ? -0.2 : 0.25,
                child: Icon(
                  Icons.eco,
                  color: Colors.green.shade700,
                  size: 28 * scale,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // flowers
    for (int i = 0; i < flowers; i++) {
      final left = xFor(i + 50);
      final top = yFor(i + 50, areaH * 0.12);
      items.add(
        Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            onTap: () => _showAffirmation("Beautiful! A flower: ${_randomAffirmation()}"),
            child: Icon(Icons.local_florist, color: Colors.pink.shade300, size: 32),
          ),
        ),
      );
    }

    // fruits
    for (int i = 0; i < fruits; i++) {
      final left = xFor(i + 80);
      final top = yFor(i + 80, areaH * 0.25);
      items.add(
        Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            onTap: () => _showAffirmation("You found a fruit! A reminder: ${_randomAffirmation()}"),
            child: Icon(Icons.apple, color: Colors.red.shade400, size: 30),
          ),
        ),
      );
    }

    return items;
  }

  Widget _buildTree(CanvasConstraintsWrapper constraintsWrapper) {
    // returns a nice tree card with trunk (container) and decorations
    return LayoutBuilder(builder: (context, c) {
      return Stack(
        children: [
          // trunk + canopy silhouette
          Positioned.fill(
            child: Center(
              child: Transform.scale(
                scale: 1.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // canopy (rounded)
                    Container(
                      width: c.maxWidth * 0.8,
                      height: c.maxHeight * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade400, Colors.green.shade700],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(200),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 18,
                              offset: const Offset(0, 8)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // trunk
                    Container(
                      width: c.maxWidth * 0.12,
                      height: c.maxHeight * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade700,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // decorations (leaves, flowers, fruits)
          ..._buildTreeDecorations(c),

          // subtle birds/particles when more growth
          if (leaves >= 15)
            Positioned(
              right: 20,
              top: 30,
              child: Icon(Icons.bubble_chart, color: Colors.amber.shade200.withOpacity(0.9), size: 26),
            ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Tree of Positivity", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () => _showAffirmation(_randomAffirmation()),
            icon: const Icon(Icons.self_improvement, color: Colors.white,),
            tooltip: "Get affirmation",
          ),
          IconButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Reset progress?"),
                  content: const Text("This will remove leaves, flowers and fruits."),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Reset")),
                  ],
                ),
              ) ??
                  false;
              if (ok) {
                await _resetProgress();
                _showAffirmation("Progress reset — a fresh start 🌱");
              }
            },
            icon: const Icon(Icons.refresh,  color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // top helper card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nurture your inner garden",
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Complete small self-care tasks to grow your tree. Tap elements for kind reminders.",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          _smallStat("Leaves", leaves, Icons.eco, Colors.green),
                          const SizedBox(height: 6),
                          _smallStat("Flowers", flowers, Icons.local_florist, Colors.pink),
                          const SizedBox(height: 6),
                          _smallStat("Fruits", fruits, Icons.apple, Colors.red),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            // tree area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: GestureDetector(
                  onTap: () => _showTreeDialog(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.green.shade50],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            // background soft sun
                            Positioned(
                              top: 20,
                              left: 30,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [Colors.yellow.shade100.withOpacity(0.8), Colors.transparent],
                                  ),
                                ),
                              ),
                            ),
                            // tree drawing & decorative items
                            _buildTree(CanvasConstraintsWrapper(
                                maxWidth: constraints.maxWidth, maxHeight: constraints.maxHeight)),
                            // Animated small pulse when adding leaf
                            if (_leafAddController.isAnimating || _leafAddController.value > 0)
                              Positioned(
                                bottom: 40,
                                left: constraints.maxWidth * 0.5 - 40,
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.8, end: 1.3).animate(CurvedAnimation(parent: _leafAddController, curve: Curves.elasticOut)),
                                  child: Icon(Icons.eco, color: Colors.green.shade600, size: 48),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            // action area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: const Text("Complete Activity", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _completeActivity,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _showTreeDialog,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.deepPurple.shade400),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Icon(Icons.info_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallStat(String label, int value, IconData icon, Color color) => Row(
    children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(width: 6),
      Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );

  void _showTreeDialog() {
    final last = lastCompletedDate == null
        ? "No activity yet"
        : "${lastCompletedDate!.year}-${lastCompletedDate!.month.toString().padLeft(2,'0')}-${lastCompletedDate!.day.toString().padLeft(2,'0')}";
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              Text("Your Tree", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoTile("Leaves", leaves.toString(), Icons.eco, Colors.green),
                  _infoTile("Flowers", flowers.toString(), Icons.local_florist, Colors.pink),
                  _infoTile("Fruits", fruits.toString(), Icons.apple, Colors.red),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.rocket_launch, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          "Streak: $streakDays day(s). Last did: $last\n\nTap any leaf/flower/fruit on the tree to read a short affirmation.")),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showAffirmation(_randomAffirmation());
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text("Give me a quick affirmation", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoTile(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

/// small wrapper to pass constraints easily to tree builder
class CanvasConstraintsWrapper {
  final double maxWidth;
  final double maxHeight;
  CanvasConstraintsWrapper({required this.maxWidth, required this.maxHeight});
}
