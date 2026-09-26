import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/sudoku/domain/entities/sudoku_difficulty.dart';
import 'package:grid_wars/feature/sudoku/domain/services/sudoku_generator.dart';

bool _isValidSolvedGrid(List<List<int>> grid) {
  for (int i = 0; i < 9; i++) {
    final rowSet = <int>{};
    final colSet = <int>{};
    for (int j = 0; j < 9; j++) {
      if (grid[i][j] < 1 || grid[i][j] > 9) return false;
      if (!rowSet.add(grid[i][j])) return false;
      if (!colSet.add(grid[j][i])) return false;
    }
  }
  for (int boxRow = 0; boxRow < 3; boxRow++) {
    for (int boxCol = 0; boxCol < 3; boxCol++) {
      final boxSet = <int>{};
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          if (!boxSet.add(grid[boxRow * 3 + r][boxCol * 3 + c])) return false;
        }
      }
    }
  }
  return true;
}

void main() {
  group('SudokuGenerator', () {
    test('generateSolvedGrid produces a fully valid Sudoku solution', () {
      final grid = SudokuGenerator.generateSolvedGrid(Random(1));
      expect(_isValidSolvedGrid(grid), isTrue);
    });

    test('countSolutions reports exactly 1 for a fully solved grid', () {
      final grid = SudokuGenerator.generateSolvedGrid(Random(2));
      expect(SudokuGenerator.countSolutions(grid), 1);
    });

    test('generatePuzzle removes the requested number of cells and stays uniquely solvable', () {
      final puzzle = SudokuGenerator.generatePuzzle(SudokuDifficulty.easy, random: Random(3));

      int emptyCount = 0;
      for (final row in puzzle.givens) {
        emptyCount += row.where((v) => v == 0).length;
      }
      expect(emptyCount, SudokuDifficulty.easy.cellsToRemove);
      expect(SudokuGenerator.countSolutions(puzzle.givens), 1);
      expect(_isValidSolvedGrid(puzzle.solution), isTrue);

      // Every given clue must match the solution.
      for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
          if (puzzle.givens[r][c] != 0) {
            expect(puzzle.givens[r][c], puzzle.solution[r][c]);
          }
        }
      }
    });
  });
}
