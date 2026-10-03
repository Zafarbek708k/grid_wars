import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/core/enums/game_item_type_enum.dart';
import 'package:grid_wars/feature/x_and_o/domain/entities/bot_difficulty.dart';
import 'package:grid_wars/feature/x_and_o/domain/services/tic_tac_toe_bot.dart';

const e = GameItemTypeEnum.empty;
const x = GameItemTypeEnum.x;
const o = GameItemTypeEnum.o;

void main() {
  group('TicTacToeBot', () {
    test('easy mode always returns one of the empty cells', () {
      final board = [x, o, x, e, e, e, e, e, e];
      for (int seed = 0; seed < 10; seed++) {
        final move = TicTacToeBot.pickMove(board, BotDifficulty.easy, random: Random(seed));
        expect(move, isNotNull);
        expect(board[move!], e);
      }
    });

    test('returns null when the board is full', () {
      final board = [x, o, x, o, x, o, x, o, x];
      expect(TicTacToeBot.pickMove(board, BotDifficulty.hard), isNull);
    });

    test('hard mode takes the winning move when available', () {
      // O has two in a row (0,1) and can win at 2 (which is still empty).
      final board = [o, o, e, x, x, e, e, e, e];
      final move = TicTacToeBot.pickMove(board, BotDifficulty.hard);
      expect(move, 2);
    });

    test('hard mode blocks the opponent\'s winning move', () {
      // X threatens to win at 2 (0,1 are X); O must block there.
      final board = [x, x, e, o, e, e, e, e, e];
      final move = TicTacToeBot.pickMove(board, BotDifficulty.hard);
      expect(move, 2);
    });

    test('hard mode never loses against random play (plays out full games)', () {
      final random = Random(7);
      for (int game = 0; game < 30; game++) {
        List<GameItemTypeEnum> board = List.filled(9, e);
        GameItemTypeEnum current = x; // X (random human) moves first

        while (true) {
          final empties = [for (int i = 0; i < 9; i++) if (board[i] == e) i];
          if (empties.isEmpty) break;

          final int move;
          if (current == x) {
            move = empties[random.nextInt(empties.length)];
          } else {
            move = TicTacToeBot.pickMove(board, BotDifficulty.hard, random: random)!;
          }
          board[move] = current;

          if (_winner(board) != null) break;
          current = current == x ? o : x;
        }

        expect(_winner(board), isNot(x), reason: 'Hard bot lost a game: $board');
      }
    });
  });
}

GameItemTypeEnum? _winner(List<GameItemTypeEnum> board) {
  const patterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];
  for (final p in patterns) {
    final a = board[p[0]], b = board[p[1]], c = board[p[2]];
    if (a != e && a == b && b == c) return a;
  }
  return null;
}
