import 'dart:ui';

import 'package:equatable/equatable.dart';

class EmojiParticle extends Equatable {
  final String emoji;
  final Offset position;
  final Offset velocity;
  final double wobblePhase;
  final double wobbleAmp;
  final double size;
  final bool isDragging;

  const EmojiParticle({
    required this.emoji,
    required this.position,
    required this.velocity,
    required this.wobblePhase,
    required this.wobbleAmp,
    required this.size,
    this.isDragging = false,
  });

  EmojiParticle copyWith({
    String? emoji,
    Offset? position,
    Offset? velocity,
    double? wobblePhase,
    double? wobbleAmp,
    double? size,
    bool? isDragging,
  }) {
    return EmojiParticle(
      emoji: emoji ?? this.emoji,
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      wobblePhase: wobblePhase ?? this.wobblePhase,
      wobbleAmp: wobbleAmp ?? this.wobbleAmp,
      size: size ?? this.size,
      isDragging: isDragging ?? this.isDragging,
    );
  }

  @override
  List<Object?> get props =>
      [emoji, position, velocity, wobblePhase, wobbleAmp, size, isDragging];
}
