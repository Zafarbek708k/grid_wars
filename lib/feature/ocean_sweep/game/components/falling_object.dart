import 'package:flame/components.dart';

/// Shared downward-drift + off-screen cleanup for trash, enemies and
/// boosters. Each subtype is otherwise a different hitbox shape/color, so
/// this only factors out the one behavior they truly share.
mixin FallingObject on PositionComponent {
  double speed = 0;
  double removeBelowY = double.infinity;

  void updateFall(double dt) {
    // add() (not .y+=) so the change notifies Flame's transform listeners —
    // plain vector_math setters write straight to storage and silently
    // skip them, leaving the collision hitbox's AABB stale.
    position.add(Vector2(0, speed * dt));
    if (position.y - size.y > removeBelowY) {
      removeFromParent();
    }
  }
}
