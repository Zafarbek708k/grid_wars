import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/tetris/domain/entities/tetromino.dart';
import 'package:grid_wars/feature/tetris/domain/services/tetris_engine.dart';

void main() {
  group('TetrisEngine', () {
    test('starts with a piece placed inside the board and not game over', () {
      final engine = TetrisEngine(random: Random(1));
      expect(engine.isGameOver, isFalse);
      expect(engine.currentCells, isNotEmpty);
      for (final cell in engine.currentCells) {
        expect(cell.x, inInclusiveRange(0, engine.columns - 1));
      }
    });

    test('moveLeft repeatedly stops once it reaches the left wall', () {
      final engine = TetrisEngine(random: Random(2));
      for (int i = 0; i < 10; i++) {
        engine.moveLeft();
      }
      expect(engine.moveLeft(), isFalse);
    });

    test('moveRight repeatedly stops once it reaches the right wall', () {
      final engine = TetrisEngine(random: Random(2));
      for (int i = 0; i < 10; i++) {
        engine.moveRight();
      }
      expect(engine.moveRight(), isFalse);
    });

    test('hardDrop locks the piece into the board and spawns a new one', () {
      final engine = TetrisEngine(random: Random(4));
      final firstType = engine.currentType;
      engine.hardDrop();

      final bool anyLocked = engine.board.any((row) => row.any((cell) => cell == firstType));
      expect(anyLocked, isTrue);
      expect(engine.isGameOver, isFalse);
    });

    test('a fully filled row is cleared and increases score and linesCleared', () {
      final engine = TetrisEngine(random: Random(3));
      engine.board[engine.rows - 1] = List<TetrominoType?>.filled(engine.columns, TetrominoType.o);
      final int scoreBefore = engine.score;

      engine.hardDrop();

      expect(engine.linesCleared, 1);
      expect(engine.score, greaterThan(scoreBefore));
    });

    test('spawning into an already-occupied spawn area ends the game', () {
      final engine = TetrisEngine(random: Random(7));
      final int spawnCol = engine.columns ~/ 2 - 2;
      final blockedCells = Tetromino.cellsFor(engine.nextType).map((p) => Point(p.x + spawnCol, p.y));
      for (final cell in blockedCells) {
        engine.board[cell.y][cell.x] = TetrominoType.t;
      }

      engine.hardDrop();

      expect(engine.isGameOver, isTrue);
    });

    test('reset clears the board, score and game-over flag', () {
      final engine = TetrisEngine(random: Random(7));
      final int spawnCol = engine.columns ~/ 2 - 2;
      final blockedCells = Tetromino.cellsFor(engine.nextType).map((p) => Point(p.x + spawnCol, p.y));
      for (final cell in blockedCells) {
        engine.board[cell.y][cell.x] = TetrominoType.t;
      }
      engine.hardDrop();
      expect(engine.isGameOver, isTrue);

      engine.reset();

      expect(engine.isGameOver, isFalse);
      expect(engine.score, 0);
      expect(engine.linesCleared, 0);
      expect(engine.board.every((row) => row.every((cell) => cell == null)), isTrue);
    });
  });
}
