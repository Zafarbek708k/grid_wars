import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;

import 'package:grid_wars/feature/snake/domain/entities/direction.dart';
import 'package:grid_wars/feature/snake/domain/services/snake_engine.dart';
import 'package:grid_wars/feature/snake/game/components/snake_board.dart';
import 'package:grid_wars/feature/snake/game/snake_config.dart';
import 'package:grid_wars/feature/snake/presentation/blocs/snake_cubit/snake_cubit.dart';

/// The Flame layer: pure rendering/ticking, no BuildContext. Collision and
/// growth rules live in [SnakeEngine]; scoring/game-over UI state lives in
/// [cubit]. This class only advances the engine on a fixed-step timer and
/// relays the outcome.
class SnakeGame extends FlameGame {
  SnakeGame({required this.cubit});

  final SnakeCubit cubit;
  final SnakeConfig config = const SnakeConfig();

  late final SnakeEngine engine;
  late final SnakeBoard board;

  double _stepTimer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final int columns = math.max(10, (size.x / config.cellSize).floor());
    final int rows = math.max(10, (size.y / config.cellSize).floor());
    engine = SnakeEngine(columns: columns, rows: rows);
    await add(board = SnakeBoard(engine: engine, cellSize: config.cellSize));
  }

  void changeDirection(Direction direction) => engine.setDirection(direction);

  void restart() {
    engine.reset();
    _stepTimer = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (cubit.state.isGameOver || cubit.state.isPaused) return;

    _stepTimer += dt;
    final double interval = config.stepInterval(cubit.state.score);
    if (_stepTimer < interval) return;
    _stepTimer = 0;

    final bool ate = engine.step();
    if (engine.isGameOver) {
      cubit.gameOver();
    } else if (ate) {
      cubit.eat();
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
