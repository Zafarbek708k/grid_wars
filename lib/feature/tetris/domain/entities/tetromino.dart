import 'dart:math';

enum TetrominoType { i, o, t, s, z, j, l }

/// Each shape is 4 cells positioned within a 4x4 bounding box (col, row),
/// rotation 0. Using one fixed box size for every piece keeps rotation a
/// single formula instead of 4 hand-authored states per piece.
abstract class Tetromino {
  static const Map<TetrominoType, List<Point<int>>> _shapes = {
    TetrominoType.i: [Point(0, 1), Point(1, 1), Point(2, 1), Point(3, 1)],
    TetrominoType.o: [Point(1, 1), Point(2, 1), Point(1, 2), Point(2, 2)],
    TetrominoType.t: [Point(1, 1), Point(0, 2), Point(1, 2), Point(2, 2)],
    TetrominoType.s: [Point(1, 1), Point(2, 1), Point(0, 2), Point(1, 2)],
    TetrominoType.z: [Point(0, 1), Point(1, 1), Point(1, 2), Point(2, 2)],
    TetrominoType.j: [Point(0, 1), Point(0, 2), Point(1, 2), Point(2, 2)],
    TetrominoType.l: [Point(2, 1), Point(0, 2), Point(1, 2), Point(2, 2)],
  };

  static List<Point<int>> cellsFor(TetrominoType type) => _shapes[type]!;

  /// Rotates a set of 4x4-box-relative cells 90° clockwise.
  static List<Point<int>> rotateCW(List<Point<int>> cells) {
    return cells.map((p) => Point(3 - p.y, p.x)).toList();
  }
}
