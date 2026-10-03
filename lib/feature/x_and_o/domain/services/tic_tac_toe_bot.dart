import 'dart:math';

import 'package:grid_wars/core/enums/game_item_type_enum.dart';
import 'package:grid_wars/feature/x_and_o/domain/entities/bot_difficulty.dart';

/// Pure Tic Tac Toe bot logic: the bot always plays O. Free of Bloc/Flutter
/// so it can be unit-tested directly.
class TicTacToeBot {
  TicTacToeBot._();

  static const List<List<int>> _winPatterns = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  /// Picks the bot's next move, or null if the board is full.
  static int? pickMove(List<GameItemTypeEnum> board, BotDifficulty difficulty, {Random? random}) {
    final List<int> empties = [for (int i = 0; i < board.length; i++) if (board[i].isEmpty) i];
    if (empties.isEmpty) return null;

    if (difficulty == BotDifficulty.easy) {
      final Random rnd = random ?? Random();
      return empties[rnd.nextInt(empties.length)];
    }

    // Hard: minimax with the bot (O) maximizing — perfect play, never loses.
    int bestScore = -2;
    int bestMove = empties.first;
    for (final move in empties) {
      final List<GameItemTypeEnum> next = List<GameItemTypeEnum>.from(board);
      next[move] = GameItemTypeEnum.o;
      final int score = _minimax(next, false);
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove;
  }

  static int _minimax(List<GameItemTypeEnum> board, bool maximizing) {
    final int? result = _evaluate(board);
    if (result != null) return result;

    final List<int> empties = [for (int i = 0; i < board.length; i++) if (board[i].isEmpty) i];

    if (maximizing) {
      int best = -2;
      for (final move in empties) {
        final List<GameItemTypeEnum> next = List<GameItemTypeEnum>.from(board);
        next[move] = GameItemTypeEnum.o;
        best = max(best, _minimax(next, false));
      }
      return best;
    } else {
      int best = 2;
      for (final move in empties) {
        final List<GameItemTypeEnum> next = List<GameItemTypeEnum>.from(board);
        next[move] = GameItemTypeEnum.x;
        best = min(best, _minimax(next, true));
      }
      return best;
    }
  }

  /// Returns 1 if O has won, -1 if X has won, 0 for a draw, or null if the
  /// game isn't over yet.
  static int? _evaluate(List<GameItemTypeEnum> board) {
    for (final pattern in _winPatterns) {
      final GameItemTypeEnum a = board[pattern[0]];
      final GameItemTypeEnum b = board[pattern[1]];
      final GameItemTypeEnum c = board[pattern[2]];
      if (!a.isEmpty && a == b && b == c) {
        return a.isO ? 1 : -1;
      }
    }
    if (!board.contains(GameItemTypeEnum.empty)) return 0;
    return null;
  }
}
