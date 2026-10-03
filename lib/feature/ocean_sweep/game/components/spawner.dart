import 'dart:math' as math;

import 'package:flame/components.dart';

import 'package:grid_wars/feature/ocean_sweep/game/components/booster.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/enemy.dart';
import 'package:grid_wars/feature/ocean_sweep/game/components/trash.dart';
import 'package:grid_wars/feature/ocean_sweep/game/ocean_game.dart';

/// Spawns trash/enemies/boosters on independent timers, each paced by
/// [OceanGame.config] and the run's current level. Only ticks while the
/// session is actually playing.
class Spawner extends Component with HasGameReference<OceanGame> {
  final math.Random _random = math.Random();

  double _trashTimer = 0;
  double _enemyTimer = 0;
  double _boosterTimer = 0;

  void reset() {
    _trashTimer = 0;
    _enemyTimer = 0;
    _boosterTimer = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.session.state.isPlaying) return;

    final int level = game.session.state.level;
    final double speed = game.config.speedForLevel(level);
    final double removeBelowY = game.size.y + 60;

    _trashTimer += dt;
    if (_trashTimer >= game.config.trashInterval) {
      _trashTimer = 0;
      game.layer.add(Trash(position: _spawnPoint(), speed: speed, removeBelowY: removeBelowY));
    }

    _enemyTimer += dt;
    if (_enemyTimer >= game.config.enemyInterval(level)) {
      _enemyTimer = 0;
      game.layer.add(Enemy(position: _spawnPoint(), speed: speed, removeBelowY: removeBelowY));
    }

    _boosterTimer += dt;
    if (_boosterTimer >= game.config.boosterInterval) {
      _boosterTimer = 0;
      game.layer.add(Booster(position: _spawnPoint(), speed: speed, removeBelowY: removeBelowY));
    }
  }

  Vector2 _spawnPoint() => Vector2(24 + _random.nextDouble() * (game.size.x - 48), -30);
}
