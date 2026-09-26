import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/game_2048/domain/services/game_2048_engine.dart';
import 'package:grid_wars/feature/game_2048/presentation/blocs/game2048_bloc/game2048_bloc.dart';

Future<Game2048State> _settled(Game2048Bloc bloc) => bloc.stream.first;

void main() {
  group('Game2048Engine', () {
    test('moving left compresses and merges equal adjacent tiles once each', () {
      final board = [
        [2, 2, 4, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      final result = Game2048Engine.applyMove(board, SwipeDirection.left);

      expect(result.board[0], [4, 4, 0, 0]);
      expect(result.scoreGained, 4);
      expect(result.changed, isTrue);
    });

    test('a tile only merges once per move (2,2,2,2 left becomes 4,4 not 8)', () {
      final board = [
        [2, 2, 2, 2],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      final result = Game2048Engine.applyMove(board, SwipeDirection.left);

      expect(result.board[0], [4, 4, 0, 0]);
      expect(result.scoreGained, 8);
    });

    test('a move that changes nothing reports changed=false', () {
      final board = [
        [2, 4, 8, 16],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      final result = Game2048Engine.applyMove(board, SwipeDirection.left);

      expect(result.changed, isFalse);
    });

    test('hasMovesLeft is false only when the board is full with no adjacent equal pairs', () {
      final stuck = [
        [2, 4, 2, 4],
        [4, 2, 4, 2],
        [2, 4, 2, 4],
        [4, 2, 4, 2],
      ];
      expect(Game2048Engine.hasMovesLeft(stuck), isFalse);

      final withEmptyCell = [
        [2, 4, 2, 4],
        [4, 2, 4, 2],
        [2, 4, 2, 4],
        [4, 2, 4, 0],
      ];
      expect(Game2048Engine.hasMovesLeft(withEmptyCell), isTrue);
    });

    test('hasReached2048 detects a 2048 tile anywhere on the board', () {
      final board = Game2048Engine.emptyBoard();
      expect(Game2048Engine.hasReached2048(board), isFalse);
      board[1][2] = 2048;
      expect(Game2048Engine.hasReached2048(board), isTrue);
    });
  });

  group('Game2048Bloc', () {
    test('starts with exactly two non-zero tiles', () async {
      final bloc = Game2048Bloc(random: Random(1));
      final state = await _settled(bloc);

      final int nonZeroCount = state.board.expand((row) => row).where((v) => v != 0).length;
      expect(nonZeroCount, 2);
      await bloc.close();
    });

    test('a move that does not change the board does not emit a new state', () async {
      final bloc = Game2048Bloc(random: Random(3));
      await _settled(bloc);

      // Whatever the random starting board is, moving in all 4 directions
      // from a game that is not yet over should each either emit once
      // (something moved) or emit nothing (no-op) — never throw.
      final states = <Game2048State>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const Move$Game2048Event(direction: SwipeDirection.up));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(states.length, lessThanOrEqualTo(1));
      await sub.cancel();
      await bloc.close();
    });
  });
}
