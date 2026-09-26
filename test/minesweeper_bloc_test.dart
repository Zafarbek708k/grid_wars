import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/minesweeper/presentation/blocs/minesweeper_bloc/minesweeper_bloc.dart';

Future<MinesweeperState> _settled(MinesweeperBloc bloc) => bloc.stream.first;

void main() {
  group('MinesweeperBloc', () {
    test('revealing a second, different cell actually emits an updated board', () async {
      // Regression test: MineCell objects used to be mutated in place and
      // reused by reference across states. Since MinesweeperState extends
      // Equatable, Bloc silently skips emitting a "new" state that compares
      // equal to the current one — so once `firstClickDone` stopped
      // changing, every reveal after the first was applied to the board
      // object but never actually emitted, leaving the UI frozen on the
      // first click's result.
      final bloc = MinesweeperBloc(random: Random(1));
      await _settled(bloc);

      // First reveal: always emits, since firstClickDone flips false->true.
      final firstFuture = bloc.stream.first;
      bloc.add(const RevealCell$MinesweeperEvent(row: 0, col: 0));
      final afterFirst = await firstFuture;
      expect(afterFirst.board[0][0].isRevealed, isTrue);

      // Find a still-unrevealed, unflagged, non-mine cell to reveal next.
      int? row, col;
      outer:
      for (int r = 0; r < afterFirst.difficulty.rows; r++) {
        for (int c = 0; c < afterFirst.difficulty.cols; c++) {
          final cell = afterFirst.board[r][c];
          if (!cell.isRevealed && !cell.isFlagged && !cell.isMine) {
            row = r;
            col = c;
            break outer;
          }
        }
      }

      expect(row, isNotNull, reason: 'expected at least one more revealable cell for this seed');

      final secondFuture = bloc.stream.first;
      bloc.add(RevealCell$MinesweeperEvent(row: row!, col: col!));
      final afterSecond = await secondFuture.timeout(
        const Duration(seconds: 2),
        onTimeout: () => throw TestFailure('Second reveal never emitted — the equality-skip bug is back.'),
      );

      expect(afterSecond.board[row][col].isRevealed, isTrue);
    });

    test('toggling a flag on a second cell also emits', () async {
      final bloc = MinesweeperBloc(random: Random(2));
      await _settled(bloc);

      final firstFuture = bloc.stream.first;
      bloc.add(const ToggleFlag$MinesweeperEvent(row: 0, col: 0));
      await firstFuture;

      final secondFuture = bloc.stream.first;
      bloc.add(const ToggleFlag$MinesweeperEvent(row: 1, col: 1));
      final afterSecond = await secondFuture.timeout(
        const Duration(seconds: 2),
        onTimeout: () => throw TestFailure('Second flag toggle never emitted.'),
      );

      expect(afterSecond.board[0][0].isFlagged, isTrue);
      expect(afterSecond.board[1][1].isFlagged, isTrue);
    });
  });
}
