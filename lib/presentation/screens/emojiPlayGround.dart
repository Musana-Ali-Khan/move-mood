
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/hudChip.dart';
import '../../core/widgets/sliderChip.dart';

class EmojiPlayground extends StatefulWidget {
  const EmojiPlayground({super.key});
  @override
  State<EmojiPlayground> createState() => _EmojiPlaygroundState();
}

class _EmojiPlaygroundState extends State<EmojiPlayground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  final rnd = Random();

  static const seedEmojis = [
    '😊','🥰','😂','🤗','😎','🤩','🙌','👍','🔥','🌈',
    '✨','💫','🌟','💖','💪','🧠','🎈','🎉','🍀','🌸',
    '🐣','🦋','🐱','🐶','🫶','🕊️','☀️','🌞','🌊','🎵'
  ];

  final List<_EmojiParticle> particles = [];

  double density = 0.8;
  bool pause = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _ensureParticles(Size size) {
    final base = (size.width * size.height / 16000).clamp(10, 120).toInt();
    final target = (base * density).clamp(10, 160).toInt();

    while (particles.length < target) {
      final e = seedEmojis[rnd.nextInt(seedEmojis.length)];
      final sz = rnd.nextDouble() * 18 + 24;
      particles.add(
        _EmojiParticle(
          emoji: e,
          position: Offset(
            rnd.nextDouble() * (size.width - sz),
            rnd.nextDouble() * (size.height - sz),
          ),
          velocity: Offset(
            (rnd.nextDouble() * 40 + 10) * (rnd.nextBool() ? 1 : -1),
            (rnd.nextDouble() * 30 + 8) * (rnd.nextBool() ? 1 : -1),
          ),
          wobblePhase: rnd.nextDouble() * pi * 2,
          wobbleAmp: rnd.nextDouble() * 6 + 3,
          size: sz,
        ),
      );
    }
    if (particles.length > target) {
      particles.removeRange(target, particles.length);
    }
  }

  void _tick(Duration now) {
    if (_last == Duration.zero) {
      _last = now;
      return;
    }
    final dt = (now - _last).inMilliseconds / 1000.0;
    _last = now;

    if (pause) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final size = renderBox.size;

    _ensureParticles(size);

    setState(() {
      for (final p in particles) {
        if (p.isDragging) continue;

        var pos = p.position + p.velocity * dt;

        p.wobblePhase += dt * 1.6;
        pos = pos.translate(0, sin(p.wobblePhase) * p.wobbleAmp * dt);

        final maxX = size.width - p.size;
        final maxY = size.height - p.size;
        if (pos.dx <= 0 && p.velocity.dx < 0) {
          p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
          pos = Offset(0, pos.dy);
        } else if (pos.dx >= maxX && p.velocity.dx > 0) {
          p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
          pos = Offset(maxX, pos.dy);
        }
        if (pos.dy <= 0 && p.velocity.dy < 0) {
          p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
          pos = Offset(pos.dx, 0);
        } else if (pos.dy >= maxY && p.velocity.dy > 0) {
          p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
          pos = Offset(pos.dx, maxY);
        }

        final breeze = Offset(
          (rnd.nextDouble() - 0.5) * 6 * dt,
          (rnd.nextDouble() - 0.5) * 6 * dt,
        );
        p.velocity += breeze;

        const maxSpeed = 70.0;
        if (p.velocity.distance > maxSpeed) {
          p.velocity = (p.velocity / p.velocity.distance) * maxSpeed;
        }

        p.position = pos;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _ensureParticles(size);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // emojis
              ...particles.map((p) => Positioned(
                left: p.position.dx,
                top: p.position.dy,
                child: _DraggableEmoji(
                  particle: p,
                  onPanStart: (details) {
                    p.isDragging = true;
                    p.dragOffset = details.localPosition;
                    HapticFeedback.selectionClick();
                  },
                  onPanUpdate: (details) {
                    final newPos = p.position + details.delta;
                    p.position = newPos;
                  },
                  onPanEnd: (_) {
                    p.isDragging = false;
                    p.velocity = p.velocity * 0.3 +
                        Offset(
                          (rnd.nextDouble() - 0.5) * 20,
                          (rnd.nextDouble() - 0.5) * 20,
                        );
                    HapticFeedback.lightImpact();
                  },
                ),
              )),

              // floating HUD bottom-right
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(
                          width: double.infinity,
                          child: SliderChip(
                            icon: Icons.mood,
                            label: 'Emojis',
                            value: density,
                            min: 0.3,
                            max: 1.5,
                            onChanged: (v) => setState(() => density = v),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HudChip(
                              icon: pause ? Icons.play_arrow : Icons.pause,
                              label: pause ? 'Play' : 'Pause',
                              onTap: () => setState(() => pause = !pause),
                            ),
                            const SizedBox(width: 12),
                            HudChip(
                              icon: Icons.refresh,
                              label: 'Shuffle',
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                setState(() {
                                  for (final p in particles) {
                                    p.velocity = Offset(
                                      (rnd.nextDouble() * 80 + 20) * (rnd.nextBool() ? 1 : -1),
                                      (rnd.nextDouble() * 80 + 20) * (rnd.nextBool() ? 1 : -1),
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // bottom tip
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Opacity(
                    opacity: 0.7,
                    child: Text(
                      'drag, fling & breathe 🌬️',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _DraggableEmoji extends StatelessWidget {
  final _EmojiParticle particle;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;

  const _DraggableEmoji({
    required this.particle,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    final child = Text(
      particle.emoji,
      style: TextStyle(fontSize: particle.size),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: particle.isDragging ? 1.2 : 1.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: particle.isDragging ? 0.95 : 1.0,
          child: child,
        ),
      ),
    );
  }
}

class _EmojiParticle {
  _EmojiParticle({
    required this.emoji,
    required this.position,
    required this.velocity,
    required this.wobblePhase,
    required this.wobbleAmp,
    required this.size,
  });

  final String emoji;
  Offset position;
  Offset velocity;
  double wobblePhase;
  double wobbleAmp;
  final double size;

  bool isDragging = false;
  Offset dragOffset = Offset.zero;
}




