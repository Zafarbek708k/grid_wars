import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/chess/domain/entities/bot_difficulty.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_bot.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_engine.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_rules.dart';

Board _emptyBoard() => List.generate(8, (_) => List<ChessPiece?>.filled(8, null));

void main() {
  group('ChessBot', () {
    test('easy always picks a move from the legal set', () {
      final engine = ChessEngine();
      final move = ChessBot.pickMove(engine, BotDifficulty.easy, random: Random(1));
      expect(move, isNotNull);
      expect(engine.allLegalMoves(engine.turn), contains(move));
    });

    test('hard always picks a move from the legal set', () {
      final engine = ChessEngine();
      final move = ChessBot.pickMove(engine, BotDifficulty.hard, random: Random(1));
      expect(move, isNotNull);
      expect(engine.allLegalMoves(engine.turn), contains(move));
    });

    test('returns null when there are no legal moves', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      // A lone, fully boxed-in king with no legal moves and not in check.
      engine.board[0][0] = const ChessPiece(PieceType.king, PieceColor.black);
      engine.board[1][2] = const ChessPiece(PieceType.king, PieceColor.white);
      engine.board[2][1] = const ChessPiece(PieceType.queen, PieceColor.white);
      engine.turn = PieceColor.black;

      expect(ChessBot.pickMove(engine, BotDifficulty.hard), isNull);
    });

    test('hard prefers capturing a free hanging queen over a quiet move', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      engine.board[7][4] = const ChessPiece(PieceType.king, PieceColor.white);
      engine.board[0][4] = const ChessPiece(PieceType.king, PieceColor.black);
      engine.board[4][4] = const ChessPiece(PieceType.rook, PieceColor.white); // e4
      engine.board[4][0] = const ChessPiece(PieceType.queen, PieceColor.black); // a4, undefended
      engine.turn = PieceColor.white;

      final move = ChessBot.pickMove(engine, BotDifficulty.hard, random: Random(1));

      expect(move, isNotNull);
      expect(move!.toRow, 4);
      expect(move.toCol, 0);
    });
  });
}
