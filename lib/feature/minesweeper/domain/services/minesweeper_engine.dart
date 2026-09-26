import 'dart:math';

import 'package:grid_wars/feature/minesweeper/domain/entities/mine_cell.dart';

/// Pure Minesweeper board logic: generation (first-click-safe), adjacency
/// counting, flood-fill reveal, and win detection. Free of Bloc/Flutter so
/// it can be unit-tested directly.
class MinesweeperEngine {
  MinesweeperEngine._();

  static List<List<MineCell>> emptyBoard(int rows, int cols) {
    return List.generate(rows, (_) => List.generate(cols, (_) => MineCell()));
  }

  /// Places [mineCount] mines on [board], never on [safeRow]/[safeCol] or
  /// its immediate neighbors, so the very first reveal can never be a mine.
  /// Mutates the board's cells in place.
  static void placeMines(List<List<MineCell>> board, int mineCount, int safeRow, int safeCol, Random random) {
    final int rows = board.length;
    final int cols = board[0].length;

    final List<(int, int)> candidates = [
      for (int r = 0; r < rows; r++)
        for (int c = 0; c < cols; c++)
          if ((r - safeRow).abs() > 1 || (c - safeCol).abs() > 1) (r, c),
    ]..shuffle(random);

    final int placedCount = min(mineCount, candidates.length);
    for (int i = 0; i < placedCount; i++) {
      final (r, c) = candidates[i];
      board[r][c].isMine = true;
    }

    _computeAdjacency(board);
  }

  static void _computeAdjacency(List<List<MineCell>> board) {
    final int rows = board.length;
    final int cols = board[0].length;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c].isMine) continue;
        int count = 0;
        for (final (dr, dc) in _neighborOffsets) {
          final int nr = r + dr, nc = c + dc;
          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && board[nr][nc].isMine) count++;
        }
        board[r][c].adjacentMines = count;
      }
    }
  }

  /// Reveals the cell at [row]/[col], flood-filling outward through
  /// zero-adjacent-mine cells. Mutates the board's cells in place.
  static void revealCell(List<List<MineCell>> board, int row, int col) {
    final int rows = board.length;
    final int cols = board[0].length;
    final List<(int, int)> stack = [(row, col)];

    while (stack.isNotEmpty) {
      final (r, c) = stack.removeLast();
      if (r < 0 || r >= rows || c < 0 || c >= cols) continue;

      final cell = board[r][c];
      if (cell.isRevealed || cell.isFlagged || cell.isMine) continue;

      cell.isRevealed = true;
      if (cell.adjacentMines == 0) {
        for (final (dr, dc) in _neighborOffsets) {
          stack.add((r + dr, c + dc));
        }
      }
    }
  }

  static void revealAllMines(List<List<MineCell>> board) {
    for (final row in board) {
      for (final cell in row) {
        if (cell.isMine) cell.isRevealed = true;
      }
    }
  }

  static bool isWin(List<List<MineCell>> board) {
    for (final row in board) {
      for (final cell in row) {
        if (!cell.isMine && !cell.isRevealed) return false;
      }
    }
    return true;
  }

  static int flaggedCount(List<List<MineCell>> board) {
    int count = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell.isFlagged) count++;
      }
    }
    return count;
  }

  static const List<(int, int)> _neighborOffsets = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1), (0, 1),
    (1, -1), (1, 0), (1, 1),
  ];
}
