import 'dart:math';

import 'package:grid_wars/feature/sudoku/domain/entities/sudoku_difficulty.dart';
import 'package:grid_wars/feature/sudoku/domain/entities/sudoku_puzzle.dart';

/// Pure Sudoku generation/solving logic: a randomized backtracking filler
/// for solved grids, and a bounded solution-counter used to dig clues out
/// of a solved grid while keeping the puzzle uniquely solvable.
class SudokuGenerator {
  SudokuGenerator._();

  static int _boxIndex(int row, int col) => (row ~/ 3) * 3 + (col ~/ 3);

  /// Fills a fresh 9x9 grid with a random valid solved Sudoku.
  static List<List<int>> generateSolvedGrid([Random? random]) {
    final rnd = random ?? Random();
    final List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
    final List<int> rowMask = List.filled(9, 0);
    final List<int> colMask = List.filled(9, 0);
    final List<int> boxMask = List.filled(9, 0);

    bool fill(int index) {
      if (index == 81) return true;
      final int row = index ~/ 9;
      final int col = index % 9;
      final int box = _boxIndex(row, col);

      final List<int> candidates = List.generate(9, (i) => i + 1)..shuffle(rnd);
      for (final value in candidates) {
        final int bit = 1 << (value - 1);
        if (rowMask[row] & bit != 0 || colMask[col] & bit != 0 || boxMask[box] & bit != 0) continue;

        grid[row][col] = value;
        rowMask[row] |= bit;
        colMask[col] |= bit;
        boxMask[box] |= bit;

        if (fill(index + 1)) return true;

        grid[row][col] = 0;
        rowMask[row] &= ~bit;
        colMask[col] &= ~bit;
        boxMask[box] &= ~bit;
      }
      return false;
    }

    fill(0);
    return grid;
  }

  /// Counts solutions of [grid] (0 = empty), stopping early once [limit] is
  /// reached — used to verify a puzzle still has exactly one solution after
  /// removing a clue.
  static int countSolutions(List<List<int>> grid, {int limit = 2}) {
    final List<int> rowMask = List.filled(9, 0);
    final List<int> colMask = List.filled(9, 0);
    final List<int> boxMask = List.filled(9, 0);
    final List<int> emptyCells = [];

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        final int value = grid[row][col];
        if (value == 0) {
          emptyCells.add(row * 9 + col);
          continue;
        }
        final int bit = 1 << (value - 1);
        final int box = _boxIndex(row, col);
        rowMask[row] |= bit;
        colMask[col] |= bit;
        boxMask[box] |= bit;
      }
    }

    int solutions = 0;

    void search(int cellIndex) {
      if (solutions >= limit) return;
      if (cellIndex == emptyCells.length) {
        solutions++;
        return;
      }
      final int pos = emptyCells[cellIndex];
      final int row = pos ~/ 9;
      final int col = pos % 9;
      final int box = _boxIndex(row, col);

      for (int value = 1; value <= 9; value++) {
        if (solutions >= limit) return;
        final int bit = 1 << (value - 1);
        if (rowMask[row] & bit != 0 || colMask[col] & bit != 0 || boxMask[box] & bit != 0) continue;

        rowMask[row] |= bit;
        colMask[col] |= bit;
        boxMask[box] |= bit;

        search(cellIndex + 1);

        rowMask[row] &= ~bit;
        colMask[col] &= ~bit;
        boxMask[box] &= ~bit;
      }
    }

    search(0);
    return solutions;
  }

  /// Generates a puzzle for [difficulty]: a fully solved grid, then digs
  /// clues out one at a time, only keeping a removal if the puzzle still
  /// has exactly one solution.
  static SudokuPuzzle generatePuzzle(SudokuDifficulty difficulty, {Random? random}) {
    final rnd = random ?? Random();
    final List<List<int>> solved = generateSolvedGrid(rnd);
    final List<List<int>> givens = solved.map((row) => List<int>.from(row)).toList();

    final List<int> positions = List.generate(81, (i) => i)..shuffle(rnd);
    int removed = 0;

    for (final pos in positions) {
      if (removed >= difficulty.cellsToRemove) break;

      final int row = pos ~/ 9;
      final int col = pos % 9;
      final int previousValue = givens[row][col];
      if (previousValue == 0) continue;

      givens[row][col] = 0;
      if (countSolutions(givens, limit: 2) == 1) {
        removed++;
      } else {
        givens[row][col] = previousValue;
      }
    }

    return SudokuPuzzle(givens: givens, solution: solved);
  }
}
