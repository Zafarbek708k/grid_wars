import 'dart:math';

import 'package:grid_wars/feature/bubble_shooter/domain/entities/bubble_color.dart';

/// Pure grid rules for Bubble Shooter — no Flutter/Flame dependency,
/// directly unit-testable. The continuous projectile physics (aiming,
/// flight, wall bounce) lives in the Flame layer since it's inherently a
/// real-time concern; once a shot lands on a cell, everything from there
/// (placement, color matching, floating-bubble drop, win/loss) is decided
/// here.
class BubbleShooterEngine {
  BubbleShooterEngine({this.columns = 8, this.rows = 14, this.dangerRow = 11, Random? random})
    : _random = random ?? Random() {
    grid = List.generate(rows, (_) => List<BubbleColor?>.filled(columns, null));
    _fillInitialRows(5);
    currentColor = _drawColor();
    nextColor = _drawColor();
  }

  final int columns;
  final int rows;
  final int dangerRow;
  final Random _random;

  late List<List<BubbleColor?>> grid;
  late BubbleColor currentColor;
  late BubbleColor nextColor;

  bool isGameOver = false;
  bool isWin = false;
  int score = 0;

  void reset() {
    grid = List.generate(rows, (_) => List<BubbleColor?>.filled(columns, null));
    _fillInitialRows(5);
    score = 0;
    isGameOver = false;
    isWin = false;
    currentColor = _drawColor();
    nextColor = _drawColor();
  }

  List<(int, int)> neighborsOf(int row, int col) {
    const List<(int, int)> evenDeltas = [(-1, -1), (-1, 0), (0, -1), (0, 1), (1, -1), (1, 0)];
    const List<(int, int)> oddDeltas = [(-1, 0), (-1, 1), (0, -1), (0, 1), (1, 0), (1, 1)];
    final deltas = row.isOdd ? oddDeltas : evenDeltas;
    return [for (final (dr, dc) in deltas) if (_inBounds(row + dr, col + dc)) (row + dr, col + dc)];
  }

  /// Places the current bubble at [row]/[col] (must be empty and in
  /// bounds), pops any connected same-color group of 3+, drops any bubbles
  /// left floating (no path back to the ceiling), updates score/win/loss,
  /// then draws the next bubble. Returns false and leaves the grid
  /// untouched if the cell wasn't actually placeable.
  bool place(int row, int col) {
    if (isGameOver || isWin || !_inBounds(row, col) || grid[row][col] != null) return false;

    grid[row][col] = currentColor;

    final group = _connectedSameColor(row, col);
    if (group.length >= 3) {
      for (final (r, c) in group) {
        grid[r][c] = null;
      }
      score += group.length * 10;
      score += _dropFloating() * 20;
    }

    if (row >= dangerRow) {
      isGameOver = true;
    } else if (_isEmpty()) {
      isWin = true;
    } else {
      currentColor = nextColor;
      nextColor = _drawColor();
    }
    return true;
  }

  bool _inBounds(int row, int col) => row >= 0 && row < rows && col >= 0 && col < columns;

  bool _isEmpty() => grid.every((r) => r.every((c) => c == null));

  BubbleColor _drawColor() => BubbleColor.values[_random.nextInt(BubbleColor.values.length)];

  void _fillInitialRows(int count) {
    for (int row = 0; row < count; row++) {
      for (int col = 0; col < columns; col++) {
        grid[row][col] = _drawColor();
      }
    }
  }

  Set<(int, int)> _connectedSameColor(int row, int col) {
    final BubbleColor? color = grid[row][col];
    if (color == null) return {};

    final visited = <(int, int)>{};
    final stack = [(row, col)];
    while (stack.isNotEmpty) {
      final cell = stack.removeLast();
      if (visited.contains(cell) || grid[cell.$1][cell.$2] != color) continue;
      visited.add(cell);
      for (final n in neighborsOf(cell.$1, cell.$2)) {
        if (!visited.contains(n)) stack.add(n);
      }
    }
    return visited;
  }

  /// Removes every bubble with no path back to row 0 (the ceiling).
  /// Returns how many were removed.
  int _dropFloating() {
    final reachable = <(int, int)>{};
    final stack = [for (int c = 0; c < columns; c++) if (grid[0][c] != null) (0, c)];
    while (stack.isNotEmpty) {
      final cell = stack.removeLast();
      if (reachable.contains(cell) || grid[cell.$1][cell.$2] == null) continue;
      reachable.add(cell);
      for (final n in neighborsOf(cell.$1, cell.$2)) {
        if (!reachable.contains(n)) stack.add(n);
      }
    }

    int removed = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        if (grid[r][c] != null && !reachable.contains((r, c))) {
          grid[r][c] = null;
          removed++;
        }
      }
    }
    return removed;
  }
}
