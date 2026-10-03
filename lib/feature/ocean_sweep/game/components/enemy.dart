import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:grid_wars/feature/ocean_sweep/game/components/falling_object.dart';

/// A jellyfish/shark stand-in. Colliding with the diver ends the run unless
/// a shield is active.
class Enemy extends RectangleHitbox with FallingObject {
  Enemy({required Vector2 position, required double speed, required double removeBelowY})
    : super(
        size: Vector2.all(28),
        position: position,
        angle: math.pi / 4,
        anchor: Anchor.center,
        collisionType: CollisionType.passive,
      ) {
    this.speed = speed;
    this.removeBelowY = removeBelowY;
    // ShapeHitbox defaults renderShape to false; this class uses the
    // hitbox itself as the visible shape, so it must opt back in.
    renderShape = true;
    paint = Paint()..color = const Color(0xFFE53935);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateFall(dt);
  }
}
