import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/chess/domain/entities/castling_rights.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_rules.dart';

Board _emptyBoard() => List.generate(8, (_) => List<ChessPiece?>.filled(8, null));

void main() {
  group('ChessRules', () {
    test('a rook slides until it hits a piece, capturing an enemy but stopping before a friend', () {
      final board = _emptyBoard();
      board[4][4] = const ChessPiece(PieceType.rook, PieceColor.white);
      board[4][6] = const ChessPiece(PieceType.pawn, PieceColor.black); // blocks/capturable to the right
      board[1][4] = const ChessPiece(PieceType.pawn, PieceColor.white); // blocks (own piece) above

      final moves = ChessRules.pseudoLegalMoves(
        board,
        4,
        4,
        rights: const CastlingRights(),
        enPassantTarget: null,
      );

      expect(moves.any((m) => m.toRow == 4 && m.toCol == 6), isTrue, reason: 'should be able to capture the enemy pawn');
      expect(moves.any((m) => m.toRow == 4 && m.toCol == 7), isFalse, reason: 'cannot slide past a capture');
      expect(moves.any((m) => m.toRow == 1 && m.toCol == 4), isFalse, reason: 'cannot land on its own pawn');
      expect(moves.any((m) => m.toRow == 2 && m.toCol == 4), isTrue, reason: 'can slide up to just before its own pawn');
    });

    test('a knight jumps over pieces and can only land on empty or enemy squares', () {
      final board = _emptyBoard();
      board[4][4] = const ChessPiece(PieceType.knight, PieceColor.white);
      board[4][5] = const ChessPiece(PieceType.pawn, PieceColor.white); // irrelevant, not a knight-move target
      board[2][5] = const ChessPiece(PieceType.pawn, PieceColor.black); // one legal landing square, capturable
      board[6][5] = const ChessPiece(PieceType.pawn, PieceColor.white); // one legal landing square, own piece, blocked

      final moves = ChessRules.pseudoLegalMoves(
        board,
        4,
        4,
        rights: const CastlingRights(),
        enPassantTarget: null,
      );

      expect(moves.any((m) => m.toRow == 2 && m.toCol == 5), isTrue);
      expect(moves.any((m) => m.toRow == 6 && m.toCol == 5), isFalse);
      expect(moves.length, 7, reason: '8 knight-move squares minus the one blocked by a friendly piece');
    });

    test('isSquareAttacked detects a sliding piece attacking along an open file', () {
      final board = _emptyBoard();
      board[0][3] = const ChessPiece(PieceType.rook, PieceColor.black);

      expect(ChessRules.isSquareAttacked(board, 6, 3, PieceColor.black), isTrue);
      expect(ChessRules.isSquareAttacked(board, 6, 4, PieceColor.black), isFalse);
    });

    test('isSquareAttacked stops at the first blocking piece', () {
      final board = _emptyBoard();
      board[0][3] = const ChessPiece(PieceType.rook, PieceColor.black);
      board[3][3] = const ChessPiece(PieceType.pawn, PieceColor.white); // blocks the file partway down

      expect(ChessRules.isSquareAttacked(board, 6, 3, PieceColor.black), isFalse);
    });

    test('a pawn can capture diagonally but not move diagonally into an empty square', () {
      final board = _emptyBoard();
      board[4][4] = const ChessPiece(PieceType.pawn, PieceColor.white); // e4
      board[3][5] = const ChessPiece(PieceType.pawn, PieceColor.black); // capturable

      final moves = ChessRules.pseudoLegalMoves(
        board,
        4,
        4,
        rights: const CastlingRights(),
        enPassantTarget: null,
      );

      expect(moves.any((m) => m.toRow == 3 && m.toCol == 5), isTrue);
      expect(moves.any((m) => m.toRow == 3 && m.toCol == 3), isFalse, reason: 'nothing to capture there');
    });
  });
}
