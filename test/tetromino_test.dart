import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/tetris/domain/entities/tetromino.dart';

void main() {
  group('Tetromino', () {
    test('every piece type has exactly 4 cells', () {
      for (final type in TetrominoType.values) {
        expect(Tetromino.cellsFor(type).length, 4);
      }
    });

    test('rotating the I piece 90 degrees turns it from horizontal to vertical', () {
      final flat = Tetromino.cellsFor(TetrominoType.i);
      final rotated = Tetromino.rotateCW(flat);
      expect(rotated.toSet(), {const Point(2, 0), const Point(2, 1), const Point(2, 2), const Point(2, 3)});
    });

    test('rotating any piece 4 times returns to its original cell set', () {
      for (final type in TetrominoType.values) {
        var cells = Tetromino.cellsFor(type);
        final original = cells.toSet();
        for (int i = 0; i < 4; i++) {
          cells = Tetromino.rotateCW(cells);
        }
        expect(cells.toSet(), original, reason: '$type should return to its original shape after 4 rotations');
      }
    });
  });
}
