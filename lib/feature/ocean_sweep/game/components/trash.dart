import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:grid_wars/feature/ocean_sweep/game/components/falling_object.dart';

/// A piece of plastic trash. Colliding with the diver scores a point.
class Trash extends CircleHitbox with FallingObject {
  Trash({required Vector2 position, required double speed, required double removeBelowY})
    : super(radius: 14, position: position, anchor: Anchor.center, collisionType: CollisionType.passive) {
    this.speed = speed;
    this.removeBelowY = removeBelowY;
    // ShapeHitbox defaults renderShape to false; this class uses the
    // hitbox itself as the visible shape, so it must opt back in.
    renderShape = true;
    paint = Paint()..color = const Color(0xFF8D6E63);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateFall(dt);
  }
}
