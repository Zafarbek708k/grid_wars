import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_engine.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_rules.dart';

Board _emptyBoard() => List.generate(8, (_) => List<ChessPiece?>.filled(8, null));

void main() {
  group('ChessEngine', () {
    test('starts with 32 pieces in the standard opening position', () {
      final engine = ChessEngine();
      int count = 0;
      for (final row in engine.board) {
        for (final cell in row) {
          if (cell != null) count++;
        }
      }
      expect(count, 32);
      expect(engine.board[7][4], const ChessPiece(PieceType.king, PieceColor.white));
      expect(engine.board[0][4], const ChessPiece(PieceType.king, PieceColor.black));
      expect(engine.turn, PieceColor.white);
    });

    test("Fool's Mate ends the game in checkmate for white in 4 half-moves", () {
      final engine = ChessEngine();
      void move(int fromRow, int fromCol, int toRow, int toCol) {
        final m = engine.legalMovesFrom(fromRow, fromCol).firstWhere((m) => m.toRow == toRow && m.toCol == toCol);
        engine.applyMove(m);
      }

      move(6, 5, 5, 5); // f2-f3
      move(1, 4, 3, 4); // e7-e5
      move(6, 6, 4, 6); // g2-g4
      move(0, 3, 4, 7); // Qd8-h4#

      expect(engine.isCheckmate, isTrue);
      expect(engine.isStalemate, isFalse);
      expect(engine.turn, PieceColor.white, reason: 'white is the side to move and the one mated');
    });

    test('en passant capture removes the pawn that just double-stepped', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      engine.board[7][4] = const ChessPiece(PieceType.king, PieceColor.white);
      engine.board[0][4] = const ChessPiece(PieceType.king, PieceColor.black);
      engine.board[3][4] = const ChessPiece(PieceType.pawn, PieceColor.white); // e5
      engine.board[1][3] = const ChessPiece(PieceType.pawn, PieceColor.black); // d7
      engine.turn = PieceColor.black;

      final doubleStep = engine.legalMovesFrom(1, 3).firstWhere((m) => m.toRow == 3 && m.toCol == 3);
      engine.applyMove(doubleStep);
      expect(engine.enPassantTarget, (2, 3));

      final ep = engine.legalMovesFrom(3, 4).firstWhere((m) => m.isEnPassant);
      engine.applyMove(ep);

      expect(engine.board[2][3], const ChessPiece(PieceType.pawn, PieceColor.white));
      expect(engine.board[3][3], isNull, reason: 'the captured pawn sat beside the destination, not on it');
      expect(engine.board[3][4], isNull);
    });

    test('kingside castling moves both the king and the rook in one move', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      engine.board[7][4] = const ChessPiece(PieceType.king, PieceColor.white);
      engine.board[7][7] = const ChessPiece(PieceType.rook, PieceColor.white);
      engine.board[0][4] = const ChessPiece(PieceType.king, PieceColor.black);
      engine.turn = PieceColor.white;

      final castle = engine.legalMovesFrom(7, 4).firstWhere((m) => m.isCastle && m.toCol == 6);
      engine.applyMove(castle);

      expect(engine.board[7][6], const ChessPiece(PieceType.king, PieceColor.white));
      expect(engine.board[7][5], const ChessPiece(PieceType.rook, PieceColor.white));
      expect(engine.board[7][7], isNull);
      expect(engine.board[7][4], isNull);
    });

    test('castling is denied when the king would pass through an attacked square', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      engine.board[7][4] = const ChessPiece(PieceType.king, PieceColor.white);
      engine.board[7][7] = const ChessPiece(PieceType.rook, PieceColor.white);
      engine.board[0][4] = const ChessPiece(PieceType.king, PieceColor.black);
      engine.board[0][5] = const ChessPiece(PieceType.rook, PieceColor.black); // rakes the f-file, incl. f1
      engine.turn = PieceColor.white;

      final moves = engine.legalMovesFrom(7, 4);
      expect(moves.any((m) => m.isCastle), isFalse);
    });

    test('a pinned piece has no legal moves that break the pin', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      engine.board[7][4] = const ChessPiece(PieceType.king, PieceColor.white);
      engine.board[5][4] = const ChessPiece(PieceType.knight, PieceColor.white); // e3, pinned
      engine.board[0][4] = const ChessPiece(PieceType.rook, PieceColor.black); // e8, pins along the e-file
      engine.board[0][0] = const ChessPiece(PieceType.king, PieceColor.black);
      engine.turn = PieceColor.white;

      expect(
        engine.legalMovesFrom(5, 4),
        isEmpty,
        reason: 'a knight can never move and stay on the same file, so a pinned knight has zero legal moves',
      );
    });

    test('a pawn reaching the last rank auto-promotes to a queen', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      engine.board[7][4] = const ChessPiece(PieceType.king, PieceColor.white);
      engine.board[0][4] = const ChessPiece(PieceType.king, PieceColor.black);
      engine.board[1][0] = const ChessPiece(PieceType.pawn, PieceColor.white); // a7
      engine.turn = PieceColor.white;

      final promo = engine.legalMovesFrom(1, 0).firstWhere((m) => m.toRow == 0);
      engine.applyMove(promo);

      expect(engine.board[0][0], const ChessPiece(PieceType.queen, PieceColor.white));
    });

    test('a lone king with no safe square and not in check is stalemate, not checkmate', () {
      final engine = ChessEngine();
      engine.board = _emptyBoard();
      engine.board[0][0] = const ChessPiece(PieceType.king, PieceColor.black); // a8
      engine.board[1][2] = const ChessPiece(PieceType.king, PieceColor.white); // c7
      engine.board[2][1] = const ChessPiece(PieceType.queen, PieceColor.white); // b6
      engine.turn = PieceColor.black;

      expect(engine.isInCheck(PieceColor.black), isFalse);
      expect(engine.allLegalMoves(PieceColor.black), isEmpty);
    });

    test('reset-equivalent: a freshly constructed engine always starts from the standard position', () {
      final a = ChessEngine();
      final b = ChessEngine();
      expect(a.board, b.board);
      expect(a.turn, b.turn);
    });
  });
}
