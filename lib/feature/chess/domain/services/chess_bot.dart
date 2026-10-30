import 'dart:math';

import 'package:grid_wars/feature/chess/domain/entities/bot_difficulty.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_move.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_engine.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_rules.dart';

/// Pure chess bot logic — free of Bloc/Flutter so it's unit-testable
/// directly, mirroring [TicTacToeBot]'s shape but scaled up: easy picks a
/// random legal move, hard runs a shallow alpha-beta minimax over material
/// (kept intentionally shallow — 2 plies past the candidate move — so it
/// stays responsive on a phone without a background isolate).
class ChessBot {
  const ChessBot._();

  static const Map<PieceType, int> _pieceValues = {
    PieceType.pawn: 100,
    PieceType.knight: 320,
    PieceType.bishop: 330,
    PieceType.rook: 500,
    PieceType.queen: 900,
    PieceType.king: 0,
  };

  static ChessMove? pickMove(ChessEngine engine, BotDifficulty difficulty, {Random? random}) {
    final moves = engine.allLegalMoves(engine.turn);
    if (moves.isEmpty) return null;

    if (difficulty == BotDifficulty.easy) {
      final rnd = random ?? Random();
      return moves[rnd.nextInt(moves.length)];
    }

    final PieceColor botColor = engine.turn;
    ChessMove best = moves.first;
    int bestScore = -1000000;
    int alpha = -1000000;
    const int beta = 1000000;

    for (final move in moves) {
      final clone = _clone(engine);
      clone.applyMove(move);
      final score = _minimax(clone, 1, alpha, beta, botColor, maximizing: false);
      if (score > bestScore) {
        bestScore = score;
        best = move;
      }
      alpha = max(alpha, score);
    }
    return best;
  }

  /// [maximizing] is true when it's [botColor]'s turn to move in [engine]
  /// (pick the highest score), false when it's the opponent's turn (they
  /// pick the lowest) — alternates every ply, same as any minimax.
  static int _minimax(ChessEngine engine, int depth, int alpha, int beta, PieceColor botColor, {required bool maximizing}) {
    if (engine.isCheckmate) {
      final bool botIsMated = engine.turn == botColor;
      return botIsMated ? -100000 - depth : 100000 + depth;
    }
    if (engine.isStalemate) return 0;
    if (depth == 0) return _evaluate(engine.board, botColor);

    final moves = engine.allLegalMoves(engine.turn);
    if (maximizing) {
      int best = -1000000;
      for (final move in moves) {
        final clone = _clone(engine);
        clone.applyMove(move);
        best = max(best, _minimax(clone, depth - 1, alpha, beta, botColor, maximizing: false));
        alpha = max(alpha, best);
        if (alpha >= beta) break;
      }
      return best;
    } else {
      int best = 1000000;
      for (final move in moves) {
        final clone = _clone(engine);
        clone.applyMove(move);
        best = min(best, _minimax(clone, depth - 1, alpha, beta, botColor, maximizing: true));
        beta = min(beta, best);
        if (alpha >= beta) break;
      }
      return best;
    }
  }

  static int _evaluate(Board board, PieceColor botColor) {
    int score = 0;
    for (final row in board) {
      for (final piece in row) {
        if (piece == null) continue;
        final value = _pieceValues[piece.type]!;
        score += piece.color == botColor ? value : -value;
      }
    }
    return score;
  }

  static ChessEngine _clone(ChessEngine engine) {
    final clone = ChessEngine();
    clone.board = [for (final row in engine.board) [...row]];
    clone.turn = engine.turn;
    clone.rights = engine.rights;
    clone.enPassantTarget = engine.enPassantTarget;
    return clone;
  }
}
