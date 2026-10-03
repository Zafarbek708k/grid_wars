import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:grid_wars/feature/ocean_sweep/game/ocean_game.dart';

/// Invisible full-screen layer so the player can drag from anywhere on
/// screen to move the diver, instead of having to touch the diver exactly.
class ControlLayer extends PositionComponent with DragCallbacks, HasGameReference<OceanGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size.clone();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!game.session.state.isPlaying) return;

    final diver = game.diver;
    final double halfW = diver.size.x / 2;
    final double halfH = diver.size.y / 2;
    final double nextX = diver.position.x + event.localDelta.x;
    final double nextY = diver.position.y + event.localDelta.y;

    // setValues (not .x=/.y=) so the change notifies Flame's transform
    // listeners — plain vector_math setters write straight to storage and
    // silently skip them, leaving the collision hitbox's AABB stale.
    diver.position.setValues(
      math.min(math.max(nextX, halfW), game.size.x - halfW),
      math.min(math.max(nextY, halfH), game.size.y - halfH),
    );
  }
}
