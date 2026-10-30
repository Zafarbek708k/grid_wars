import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/bubble_shooter/domain/entities/bubble_color.dart';
import 'package:grid_wars/feature/bubble_shooter/domain/services/bubble_shooter_engine.dart';

/// Empties the grid so each test can set up its own exact scenario,
/// instead of fighting the random initial fill.
void _clear(BubbleShooterEngine engine) {
  engine.grid = List.generate(engine.rows, (_) => List<BubbleColor?>.filled(engine.columns, null));
}

void main() {
  group('BubbleShooterEngine', () {
    test('starts with the first 5 rows filled and the rest empty', () {
      final engine = BubbleShooterEngine(random: Random(1));
      for (int row = 0; row < 5; row++) {
        expect(engine.grid[row].every((c) => c != null), isTrue, reason: 'row $row should be fully filled');
      }
      for (int row = 5; row < engine.rows; row++) {
        expect(engine.grid[row].every((c) => c == null), isTrue, reason: 'row $row should be empty');
      }
      expect(engine.isGameOver, isFalse);
      expect(engine.isWin, isFalse);
    });

    test('neighborsOf returns 6 in-bounds neighbors for an interior cell', () {
      final engine = BubbleShooterEngine(random: Random(1));
      expect(engine.neighborsOf(5, 3).length, 6);
      expect(engine.neighborsOf(6, 3).length, 6);
    });

    test('place fails on an already-occupied cell', () {
      final engine = BubbleShooterEngine(random: Random(1));
      expect(engine.place(0, 0), isFalse);
    });

    test('a connecting group of 3+ same-color bubbles pops and scores', () {
      final engine = BubbleShooterEngine(random: Random(1));
      _clear(engine);
      engine.grid[5][2] = BubbleColor.red;
      engine.grid[5][3] = BubbleColor.red;
      engine.grid[0][0] = BubbleColor.blue; // keep the board non-empty so this stays a pop test, not a win test
      engine.currentColor = BubbleColor.red;

      final placed = engine.place(5, 4);

      expect(placed, isTrue);
      expect(engine.score, 30);
      expect(engine.grid[5][2], isNull);
      expect(engine.grid[5][3], isNull);
      expect(engine.grid[5][4], isNull);
      expect(engine.isGameOver, isFalse);
      expect(engine.isWin, isFalse);
    });

    test('a group smaller than 3 does not pop', () {
      final engine = BubbleShooterEngine(random: Random(1));
      _clear(engine);
      engine.grid[5][2] = BubbleColor.red;
      engine.currentColor = BubbleColor.red;

      engine.place(5, 3);

      expect(engine.score, 0);
      expect(engine.grid[5][2], BubbleColor.red);
      expect(engine.grid[5][3], BubbleColor.red);
    });

    test('popping a group drops bubbles left with no path back to the ceiling', () {
      final engine = BubbleShooterEngine(random: Random(1));
      _clear(engine);
      engine.grid[0][3] = BubbleColor.blue; // ceiling anchor
      engine.grid[1][2] = BubbleColor.red;
      engine.grid[2][3] = BubbleColor.red;
      engine.grid[3][3] = BubbleColor.green; // only reachable via (2,3)
      engine.currentColor = BubbleColor.red;

      // Completes the red group {(1,2), (1,3), (2,3)}.
      engine.place(1, 3);

      expect(engine.score, 50); // 3 popped * 10 + 1 floating * 20
      expect(engine.grid[1][2], isNull);
      expect(engine.grid[1][3], isNull);
      expect(engine.grid[2][3], isNull);
      expect(engine.grid[3][3], isNull, reason: 'lost its only path to the ceiling and should have dropped');
      expect(engine.grid[0][3], BubbleColor.blue, reason: 'still connected, should stay');
    });

    test('placing at or past the danger row ends the game', () {
      final engine = BubbleShooterEngine(random: Random(1));
      engine.currentColor = BubbleColor.red;
      engine.place(engine.dangerRow, 0);
      expect(engine.isGameOver, isTrue);
    });

    test('clearing every bubble wins the game', () {
      final engine = BubbleShooterEngine(random: Random(1));
      _clear(engine);
      engine.grid[5][0] = BubbleColor.red;
      engine.grid[5][1] = BubbleColor.red;
      engine.currentColor = BubbleColor.red;

      engine.place(5, 2);

      expect(engine.isWin, isTrue);
      expect(engine.isGameOver, isFalse);
    });

    test('reset restores the initial fill, clears score and game-over flags', () {
      final engine = BubbleShooterEngine(random: Random(1));
      engine.currentColor = BubbleColor.red;
      engine.place(engine.dangerRow, 0);
      expect(engine.isGameOver, isTrue);

      engine.reset();

      expect(engine.isGameOver, isFalse);
      expect(engine.isWin, isFalse);
      expect(engine.score, 0);
      for (int row = 0; row < 5; row++) {
        expect(engine.grid[row].every((c) => c != null), isTrue);
      }
    });
  });
}
