import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Vertical ocean gradient plus a handful of lazily rising bubbles — purely
/// decorative, never participates in collisions.
class OceanBackground extends PositionComponent {
  final List<_Bubble> _bubbles = List.generate(14, (_) => _Bubble.random());
  final math.Random _random = math.Random();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size.clone();
  }

  @override
  void render(Canvas canvas) {
    final Rect rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final Paint gradientPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0B486B), Color(0xFF0E2A3B)],
      ).createShader(rect);
    canvas.drawRect(rect, gradientPaint);

    final Paint bubblePaint = Paint()..color = const Color(0x33FFFFFF);
    for (final bubble in _bubbles) {
      canvas.drawCircle(Offset(bubble.x * size.x, bubble.y * size.y), bubble.radius, bubblePaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final bubble in _bubbles) {
      bubble.y -= bubble.speed * dt;
      if (bubble.y < -0.05) {
        bubble.y = 1.05;
        bubble.x = _random.nextDouble();
      }
    }
  }
}

class _Bubble {
  _Bubble({required this.x, required this.y, required this.radius, required this.speed});

  double x;
  double y;
  final double radius;
  final double speed;

  static _Bubble random() {
    final math.Random random = math.Random();
    return _Bubble(
      x: random.nextDouble(),
      y: random.nextDouble(),
      radius: 2 + random.nextDouble() * 4,
      speed: 0.04 + random.nextDouble() * 0.06,
    );
  }
}
