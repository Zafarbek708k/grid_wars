import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;

import 'package:grid_wars/feature/tetris/domain/services/tetris_engine.dart';
import 'package:grid_wars/feature/tetris/game/components/tetris_board.dart';
import 'package:grid_wars/feature/tetris/game/tetris_config.dart';
import 'package:grid_wars/feature/tetris/presentation/blocs/tetris_cubit/tetris_cubit.dart';

/// The Flame layer: pure rendering/ticking, no BuildContext. Collision,
/// rotation and line-clear rules live in [TetrisEngine]; scoring/game-over
/// UI state lives in [cubit]. This class only advances the engine (via
/// gravity or player input) and relays the outcome.
class TetrisGame extends FlameGame {
  TetrisGame({required this.cubit});

  final TetrisCubit cubit;
  final TetrisConfig config = const TetrisConfig();

  late final TetrisEngine engine;
  late final TetrisBoard board;

  double _stepTimer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    engine = TetrisEngine();
    final double cellSize = math.min(size.x / engine.columns, size.y / engine.rows);
    final double boardWidth = cellSize * engine.columns;
    final double boardHeight = cellSize * engine.rows;
    board = TetrisBoard(engine: engine, cellSize: cellSize)
      ..position = Vector2((size.x - boardWidth) / 2, (size.y - boardHeight) / 2);
    await add(board);
    _syncCubit();
  }

  void moveLeft() => _act(engine.moveLeft);

  void moveRight() => _act(engine.moveRight);

  void rotate() => _act(engine.rotate);

  void softDrop() => _act(engine.step);

  void hardDrop() => _act(engine.hardDrop);

  void restart() {
    engine.reset();
    _stepTimer = 0;
    _syncCubit();
  }

  void _act(void Function() action) {
    if (cubit.state.isGameOver || cubit.state.isPaused) return;
    action();
    _syncCubit();
  }

  void _syncCubit() {
    if (engine.isGameOver) {
      cubit.gameOver(score: engine.score);
    } else {
      cubit.sync(score: engine.score, level: engine.level, lines: engine.linesCleared, next: engine.nextType.name.toUpperCase());
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (cubit.state.isGameOver || cubit.state.isPaused) return;

    _stepTimer += dt;
    final double interval = config.dropInterval(engine.level);
    if (_stepTimer < interval) return;
    _stepTimer = 0;

    engine.step();
    _syncCubit();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (state != AppLifecycleState.resumed) {
      cubit.pause();
    }
  }
}
