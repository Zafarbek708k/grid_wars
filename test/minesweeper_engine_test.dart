import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/minesweeper/domain/services/minesweeper_engine.dart';

void main() {
  group('MinesweeperEngine', () {
    test('placeMines never places a mine on the safe cell or its neighbors', () {
      for (int seed = 0; seed < 20; seed++) {
        final board = MinesweeperEngine.emptyBoard(9, 9);
        MinesweeperEngine.placeMines(board, 10, 4, 4, Random(seed));

        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            expect(board[4 + dr][4 + dc].isMine, isFalse, reason: 'seed=$seed dr=$dr dc=$dc');
          }
        }
      }
    });

    test('placeMines places exactly the requested number of mines', () {
      final board = MinesweeperEngine.emptyBoard(9, 9);
      MinesweeperEngine.placeMines(board, 10, 0, 0, Random(1));

      final int mineCount = board.expand((row) => row).where((cell) => cell.isMine).length;
      expect(mineCount, 10);
    });

    test('adjacentMines counts are correct around a known mine layout', () {
      final board = MinesweeperEngine.emptyBoard(3, 3);
      board[0][0].isMine = true;
      MinesweeperEngine.placeMines(board, 0, 2, 2, Random(1)); // recompute adjacency, add 0 more mines

      expect(board[0][1].adjacentMines, 1);
      expect(board[1][0].adjacentMines, 1);
      expect(board[1][1].adjacentMines, 1);
      expect(board[2][2].adjacentMines, 0);
    });

    test('revealCell flood-fills through zero-adjacent cells and stops at numbered cells', () {
      // A single mine in the corner of a 5x5 board: revealing the far
      // corner should flood-fill almost the entire board.
      final board = MinesweeperEngine.emptyBoard(5, 5);
      board[0][0].isMine = true;
      MinesweeperEngine.placeMines(board, 0, 4, 4, Random(1));

      MinesweeperEngine.revealCell(board, 4, 4);

      final int revealedCount = board.expand((row) => row).where((cell) => cell.isRevealed).length;
      // Every non-mine cell should end up revealed since only one mine
      // exists far from the flood-fill origin.
      expect(revealedCount, 24);
      expect(board[0][0].isRevealed, isFalse);
    });

    test('isWin is true only once every non-mine cell is revealed', () {
      final board = MinesweeperEngine.emptyBoard(2, 2);
      board[0][0].isMine = true;
      MinesweeperEngine.placeMines(board, 0, 1, 1, Random(1));

      expect(MinesweeperEngine.isWin(board), isFalse);

      board[0][1].isRevealed = true;
      board[1][0].isRevealed = true;
      board[1][1].isRevealed = true;

      expect(MinesweeperEngine.isWin(board), isTrue);
    });
  });
}
