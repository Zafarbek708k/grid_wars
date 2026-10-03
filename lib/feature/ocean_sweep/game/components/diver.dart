import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:grid_wars/feature/ocean_sweep/game/components/booster.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/enemy.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/trash.dart';
import 'package:grid_wars/feature/ocean_sweep/game/ocean_game.dart';

/// The player. [ControlLayer] moves it directly by setting [position]; this
/// class only reacts to whatever it touches, forwarding every outcome back
/// to [OceanGame] which owns the actual game rules.
class Diver extends CircleHitbox with HasGameReference<OceanGame> {
  Diver() : super(radius: 22, anchor: Anchor.center, collisionType: CollisionType.active) {
    // ShapeHitbox defaults renderShape to false (hitboxes are normally
    // invisible collision volumes); this class uses the hitbox itself as
    // the visible shape, so it must opt back in.
    renderShape = true;
    paint = Paint()..color = const Color(0xFF29B6F6);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Trash) {
      game.collectTrash(other);
    } else if (other is Booster) {
      game.collectBooster(other);
    } else if (other is Enemy) {
      game.hitEnemy(other);
    }
  }
}
