import 'dart:math';

import 'package:grid_wars/feature/game_2048/domain/entities/swipe_direction.dart';

/// Pure 2048 board logic: sliding/merging, tile spawning, and game-over
/// detection. Kept free of Bloc/Flutter so it can be unit-tested directly.
class Game2048Engine {
  Game2048Engine._();

  static const int boardSize = 4;

  static List<List<int>> emptyBoard() => List.generate(boardSize, (_) => List.filled(boardSize, 0));

  static List<List<int>> withRandomTile(List<List<int>> board, Random random) {
    final List<(int, int)> emptyCells = [
      for (int r = 0; r < boardSize; r++)
        for (int c = 0; c < boardSize; c++)
          if (board[r][c] == 0) (r, c),
    ];
    if (emptyCells.isEmpty) return board;

    final (row, col) = emptyCells[random.nextInt(emptyCells.length)];
    final List<List<int>> newBoard = board.map((row) => List<int>.from(row)).toList();
    newBoard[row][col] = random.nextDouble() < 0.9 ? 2 : 4;
    return newBoard;
  }

  /// Slides and merges every row/column of [board] one step towards
  /// [direction], returning the resulting board, the score gained from
  /// merges, and whether anything actually moved.
  static ({List<List<int>> board, int scoreGained, bool changed}) applyMove(List<List<int>> board, SwipeDirection direction) {
    final List<List<int>> result = List.generate(boardSize, (_) => List.filled(boardSize, 0));
    int scoreGained = 0;
    bool changed = false;

    for (int i = 0; i < boardSize; i++) {
      final bool isRow = direction == SwipeDirection.left || direction == SwipeDirection.right;
      final bool isReversed = direction == SwipeDirection.right || direction == SwipeDirection.down;

      List<int> line = isRow ? board[i] : List.generate(boardSize, (r) => board[r][i]);
      if (isReversed) line = line.reversed.toList();

      final merged = _mergeLine(line);
      scoreGained += merged.scoreGained;

      final List<int> finalLine = isReversed ? merged.line.reversed.toList() : merged.line;

      if (isRow) {
        result[i] = finalLine;
      } else {
        for (int r = 0; r < boardSize; r++) {
          result[r][i] = finalLine[r];
        }
      }

      final List<int> original = isRow ? board[i] : List.generate(boardSize, (r) => board[r][i]);
      if (!_lineEquals(original, finalLine)) changed = true;
    }

    return (board: result, scoreGained: scoreGained, changed: changed);
  }

  /// Compresses non-zero values towards the front of [line] and merges
  /// equal adjacent pairs once each, padding the rest with zeros.
  static ({List<int> line, int scoreGained}) _mergeLine(List<int> line) {
    final List<int> nonZero = line.where((v) => v != 0).toList();
    final List<int> merged = [];
    int scoreGained = 0;

    int i = 0;
    while (i < nonZero.length) {
      if (i + 1 < nonZero.length && nonZero[i] == nonZero[i + 1]) {
        final int mergedValue = nonZero[i] * 2;
        merged.add(mergedValue);
        scoreGained += mergedValue;
        i += 2;
      } else {
        merged.add(nonZero[i]);
        i += 1;
      }
    }

    while (merged.length < line.length) {
      merged.add(0);
    }

    return (line: merged, scoreGained: scoreGained);
  }

  static bool _lineEquals(List<int> a, List<int> b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool hasMovesLeft(List<List<int>> board) {
    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize; c++) {
        if (board[r][c] == 0) return true;
        if (c + 1 < boardSize && board[r][c] == board[r][c + 1]) return true;
        if (r + 1 < boardSize && board[r][c] == board[r + 1][c]) return true;
      }
    }
    return false;
  }

  static bool hasReached2048(List<List<int>> board) => board.any((row) => row.any((value) => value >= 2048));
}
