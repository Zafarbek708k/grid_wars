import 'dart:math';

import 'package:grid_wars/feature/snake/domain/entities/direction.dart';

/// Pure grid logic for Snake — no Flutter/Flame dependency, directly
/// unit-testable. The Flame layer only ever calls [step]/[setDirection] and
/// reads [body]/[food]/[isGameOver] to render; every rule (collision,
/// growth, food placement) lives here.
class SnakeEngine {
  SnakeEngine({required this.columns, required this.rows, Random? random}) : _random = random ?? Random() {
    reset();
  }

  final int columns;
  final int rows;
  final Random _random;

  late List<Point<int>> body;
  late Point<int> food;
  late Direction direction;
  Direction? _pendingDirection;
  bool isGameOver = false;

  void reset() {
    final int startX = columns ~/ 2;
    final int startY = rows ~/ 2;
    body = [Point(startX, startY), Point(startX - 1, startY), Point(startX - 2, startY)];
    direction = Direction.right;
    _pendingDirection = null;
    isGameOver = false;
    _spawnFood();
  }

  /// Buffers a direction change, applied on the next [step]. A direct
  /// reversal is ignored so the snake can't double back into itself.
  void setDirection(Direction next) {
    if (isGameOver || next == direction.opposite) return;
    _pendingDirection = next;
  }

  /// Advances the snake by one grid cell. Returns true if food was eaten.
  bool step() {
    if (isGameOver) return false;
    if (_pendingDirection != null) {
      direction = _pendingDirection!;
      _pendingDirection = null;
    }

    final Point<int> head = body.first;
    final Point<int> next = Point(head.x + direction.dx, head.y + direction.dy);

    if (next.x < 0 || next.x >= columns || next.y < 0 || next.y >= rows || body.contains(next)) {
      isGameOver = true;
      return false;
    }

    body.insert(0, next);
    final bool ate = next == food;
    if (ate) {
      _spawnFood();
    } else {
      body.removeLast();
    }
    return ate;
  }

  void _spawnFood() {
    if (body.length >= columns * rows) return;
    Point<int> candidate;
    do {
      candidate = Point(_random.nextInt(columns), _random.nextInt(rows));
    } while (body.contains(candidate));
    food = candidate;
  }
}
