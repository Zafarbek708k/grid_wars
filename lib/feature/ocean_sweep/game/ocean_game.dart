import 'dart:async';

import 'package:flame/components.dart' show PositionComponent;
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;

import 'package:grid_wars/feature/ocean_sweep/game/components/booster.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/control_layer.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/diver.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/enemy.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/falling_object.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/ocean_background.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/spawner.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/trash.dart';
import 'package:grid_wars/feature/ocean_sweep/game/ocean_config.dart';
import 'package:grid_wars/feature/ocean_sweep/game/ocean_feedback.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_session_cubit/ocean_session_cubit.dart';

/// The Flame layer: pure rendering/physics, no BuildContext. Every rule
/// about scoring, levels and game-over lives in [session]; this class only
/// spawns/moves shapes and reports collisions back to it.
class OceanGame extends FlameGame with HasCollisionDetection {
  OceanGame({required this.session, required this.feedback});

  final OceanSessionCubit session;
  final OceanFeedback feedback;
  final OceanConfig config = const OceanConfig();

  late final Diver diver;
  late final Spawner spawner;

  /// Every gameplay component (hitboxes included) lives under this single
  /// [PositionComponent], because [FlameGame] itself is not one — a
  /// [ShapeHitbox] mounted directly under it throws "needs a
  /// PositionComponent ancestor". [Spawner] adds new objects here too.
  late final PositionComponent layer;

  double _shieldRemaining = 0;
  StreamSubscription<OceanSessionState>? _sub;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(layer = PositionComponent());
    await layer.addAll([OceanBackground(), diver = Diver(), spawner = Spawner(), ControlLayer()]);
    _resetDiverPosition();

    _sub = session.stream.listen(_onSessionState);
    _onSessionState(session.state);
  }

  @override
  void onRemove() {
    _sub?.cancel();
    super.onRemove();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _resetDiverPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_shieldRemaining > 0) {
      _shieldRemaining = (_shieldRemaining - dt).clamp(0, config.shieldDuration);
      session.updateShield(_shieldRemaining.ceil());
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (state != AppLifecycleState.resumed) {
      session.pause();
    }
  }

  /// Clears every falling object and puts the diver back at the start,
  /// ready for a fresh run (called right before [OceanSessionCubit.start]).
  void reset() {
    for (final component in layer.children.whereType<FallingObject>().toList()) {
      component.removeFromParent();
    }
    spawner.reset();
    _shieldRemaining = 0;
    _resetDiverPosition();
  }

  void collectTrash(Trash trash) {
    trash.removeFromParent();
    session.collectTrash();
    feedback.collect();
  }

  void collectBooster(Booster booster) {
    booster.removeFromParent();
    _shieldRemaining = config.shieldDuration;
    session.updateShield(_shieldRemaining.ceil());
    feedback.shield();
  }

  void hitEnemy(Enemy enemy) {
    enemy.removeFromParent();
    final bool ended = session.hitEnemy();
    feedback.hit();
    if (!ended) {
      // The shield absorbed the hit — consume the charge immediately.
      _shieldRemaining = 0;
      session.updateShield(0);
    }
  }

  void _onSessionState(OceanSessionState state) {
    if (state.status == OceanStatus.playing) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void _resetDiverPosition() {
    diver.position = Vector2(size.x / 2, size.y - 90);
  }
}
