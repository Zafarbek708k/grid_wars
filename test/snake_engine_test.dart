import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/snake/domain/entities/direction.dart';
import 'package:grid_wars/feature/snake/domain/services/snake_engine.dart';

void main() {
  group('SnakeEngine', () {
    test('starts with a 3-segment body moving right and food placed somewhere else', () {
      final engine = SnakeEngine(columns: 20, rows: 20, random: Random(1));
      expect(engine.body.length, 3);
      expect(engine.direction, Direction.right);
      expect(engine.isGameOver, isFalse);
      expect(engine.body.contains(engine.food), isFalse);
    });

    test('step moves the head by one cell and keeps the body length the same without food', () {
      final engine = SnakeEngine(columns: 20, rows: 20, random: Random(1));
      final startLength = engine.body.length;
      final headBefore = engine.body.first;

      // Food is unlikely to be directly ahead; force it away so this step
      // is a guaranteed non-eating move.
      engine.food = Point(headBefore.x, headBefore.y + 5);
      engine.step();

      expect(engine.body.length, startLength);
      expect(engine.body.first, Point(headBefore.x + 1, headBefore.y));
    });

    test('eating food grows the snake and does not remove the tail', () {
      final engine = SnakeEngine(columns: 20, rows: 20, random: Random(1));
      final startLength = engine.body.length;
      final head = engine.body.first;
      engine.food = Point(head.x + 1, head.y);

      final ate = engine.step();

      expect(ate, isTrue);
      expect(engine.body.length, startLength + 1);
    });

    test('hitting a wall ends the game', () {
      final engine = SnakeEngine(columns: 5, rows: 5, random: Random(1));
      // Walk the snake to the right wall.
      for (var i = 0; i < 10 && !engine.isGameOver; i++) {
        engine.step();
      }
      expect(engine.isGameOver, isTrue);
    });

    test('a direct reversal is ignored so the snake cannot run into itself immediately', () {
      final engine = SnakeEngine(columns: 20, rows: 20, random: Random(1));
      expect(engine.direction, Direction.right);
      engine.setDirection(Direction.left);
      engine.food = Point(-100, -100); // keep this step a non-eating move
      engine.step();
      expect(engine.direction, Direction.right);
    });

    test('running into its own body ends the game', () {
      final engine = SnakeEngine(columns: 20, rows: 20, random: Random(1));
      // Grow the snake a bit by eating straight ahead a few times, then
      // double back into the body via a loop of turns.
      for (var i = 0; i < 3; i++) {
        final head = engine.body.first;
        engine.food = Point(head.x + 1, head.y);
        engine.step();
      }
      engine.setDirection(Direction.down);
      engine.food = Point(-100, -100);
      engine.step();
      engine.setDirection(Direction.left);
      engine.step();
      engine.setDirection(Direction.up);
      engine.step();

      expect(engine.isGameOver, isTrue);
    });

    test('reset clears game-over and restores the starting body', () {
      final engine = SnakeEngine(columns: 5, rows: 5, random: Random(1));
      for (var i = 0; i < 10 && !engine.isGameOver; i++) {
        engine.step();
      }
      expect(engine.isGameOver, isTrue);

      engine.reset();

      expect(engine.isGameOver, isFalse);
      expect(engine.body.length, 3);
      expect(engine.direction, Direction.right);
    });
  });
}
