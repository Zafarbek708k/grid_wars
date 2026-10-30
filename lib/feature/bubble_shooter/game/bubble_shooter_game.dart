import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;

import 'package:grid_wars/feature/bubble_shooter/domain/services/bubble_grid_layout.dart';
import 'package:grid_wars/feature/bubble_shooter/domain/services/bubble_shooter_engine.dart';
import 'package:grid_wars/feature/bubble_shooter/game/bubble_shooter_config.dart';
import 'package:grid_wars/feature/bubble_shooter/game/components/bubble_board_view.dart';
import 'package:grid_wars/feature/bubble_shooter/presentation/blocs/bubble_shooter_cubit/bubble_shooter_cubit.dart';

/// The Flame layer: owns the continuous projectile physics (aiming,
/// flight, wall bounce) since that's inherently real-time — but once a
/// shot lands, every rule (placement, matching, floating-drop, win/loss)
/// is decided by [BubbleShooterEngine]. Scoring/game-over UI state lives
/// in [cubit].
class BubbleShooterGame extends FlameGame {
  BubbleShooterGame({required this.cubit});

  final BubbleShooterCubit cubit;
  final BubbleShooterConfig config = const BubbleShooterConfig();

  static const int columns = 8;

  late BubbleShooterEngine engine;
  late BubbleGridLayout layout;

  Vector2? aimDirection;
  Vector2? projectilePosition;
  Vector2? _projectileVelocity;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final double cellSize = size.x / columns;
    final double rowHeight = cellSize * 0.87;
    final double shooterClearance = cellSize * 2.4;
    final int rows = math.max(10, ((size.y - shooterClearance) / rowHeight).floor());
    final int dangerRow = math.max(6, rows - 3);

    engine = BubbleShooterEngine(columns: columns, rows: rows, dangerRow: dangerRow);
    layout = BubbleGridLayout(columns: columns, cellSize: cellSize);
    await add(BubbleBoardView());
    _syncCubit();
  }

  Vector2 get shooterPosition => Vector2(size.x / 2, size.y - layout.cellSize * 0.6);

  /// Updates the aim direction toward [scenePosition], clamped so the
  /// player can never aim sideways or downward.
  void updateAim(Vector2 scenePosition) {
    if (projectilePosition != null || cubit.state.isGameOver || cubit.state.isPaused) return;
    final Vector2 dir = scenePosition - shooterPosition;
    if (dir.length < 1) return;

    final double angle = math.atan2(dir.x, -dir.y); // 0 = straight up, + = right, - = left
    final double clamped = math.min(math.max(angle, -config.maxAimAngleFromVertical), config.maxAimAngleFromVertical);
    aimDirection = Vector2(math.sin(clamped), -math.cos(clamped));
  }

  void clearAim() => aimDirection = null;

  void fire() {
    if (aimDirection == null || projectilePosition != null) return;
    if (cubit.state.isGameOver || cubit.state.isPaused) return;
    projectilePosition = shooterPosition.clone();
    _projectileVelocity = aimDirection! * config.projectileSpeed;
    aimDirection = null;
  }

  void restart() {
    engine.reset();
    projectilePosition = null;
    _projectileVelocity = null;
    aimDirection = null;
    _syncCubit();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (cubit.state.isGameOver || cubit.state.isPaused) return;

    final Vector2? pos = projectilePosition;
    final Vector2? vel = _projectileVelocity;
    if (pos == null || vel == null) return;

    pos.x += vel.x * dt;
    pos.y += vel.y * dt;

    final double radius = layout.cellSize * 0.46;
    if (pos.x - radius < 0) {
      pos.x = radius;
      vel.x = -vel.x;
    } else if (pos.x + radius > size.x) {
      pos.x = size.x - radius;
      vel.x = -vel.x;
    }

    if (_hasLanded(pos, radius)) {
      _land(pos);
    }
  }

  bool _hasLanded(Vector2 pos, double radius) {
    if (pos.y - radius <= 0) return true;
    final double thresholdSq = layout.cellSize * layout.cellSize * 0.85;
    for (int row = 0; row < engine.rows; row++) {
      for (int col = 0; col < engine.columns; col++) {
        if (engine.grid[row][col] == null) continue;
        final (cx, cy) = layout.cellCenter(row, col);
        final double dx = cx - pos.x;
        final double dy = cy - pos.y;
        if (dx * dx + dy * dy < thresholdSq) return true;
      }
    }
    return false;
  }

  void _land(Vector2 pos) {
    var (row, col) = layout.nearestCell(pos.x, pos.y);
    if (engine.grid[row][col] != null) {
      final empty = engine.neighborsOf(row, col).where((c) => engine.grid[c.$1][c.$2] == null);
      if (empty.isNotEmpty) (row, col) = empty.first;
    }
    engine.place(row, col);
    projectilePosition = null;
    _projectileVelocity = null;
    _syncCubit();
  }

  void _syncCubit() {
    if (engine.isGameOver || engine.isWin) {
      cubit.gameOver(score: engine.score, won: engine.isWin);
    } else {
      cubit.sync(score: engine.score, current: engine.currentColor.name, next: engine.nextColor.name);
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (state != AppLifecycleState.resumed) {
      cubit.pause();
    }
  }
}
