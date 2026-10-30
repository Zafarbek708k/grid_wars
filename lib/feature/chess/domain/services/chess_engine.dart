import 'package:grid_wars/feature/chess/domain/entities/castling_rights.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_move.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_rules.dart';

/// Owns one chess game's state (board, turn, castling rights, en-passant
/// target, check/checkmate/stalemate) and is the only thing that mutates
/// the board. Move *rules* live in [ChessRules]; this class additionally
/// filters out any pseudo-legal move that would leave the mover's own king
/// in check, by simulating it on a cloned board first.
///
/// Known simplifications (documented, not bugs): no threefold-repetition
/// or 50-move-rule draw detection, and pawns always auto-promote to queen.
class ChessEngine {
  ChessEngine() : board = _initialBoard();

  Board board;
  PieceColor turn = PieceColor.white;
  CastlingRights rights = const CastlingRights();
  (int, int)? enPassantTarget;
  ChessMove? lastMove;

  bool isCheckmate = false;
  bool isStalemate = false;

  bool get isGameOver => isCheckmate || isStalemate;

  static List<List<ChessPiece?>> initialBoard() => _initialBoard();

  static Board _initialBoard() {
    final board = List.generate(8, (_) => List<ChessPiece?>.filled(8, null));
    const backRank = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ];
    for (int c = 0; c < 8; c++) {
      board[0][c] = ChessPiece(backRank[c], PieceColor.black);
      board[1][c] = const ChessPiece(PieceType.pawn, PieceColor.black);
      board[6][c] = const ChessPiece(PieceType.pawn, PieceColor.white);
      board[7][c] = ChessPiece(backRank[c], PieceColor.white);
    }
    return board;
  }

  bool isInCheck(PieceColor color) {
    final king = ChessRules.findKing(board, color);
    if (king == null) return false;
    return ChessRules.isSquareAttacked(board, king.$1, king.$2, color.opposite);
  }

  /// Fully legal moves for the piece at [row]/[col] — empty if there's no
  /// piece there, it isn't [turn]'s piece, or none of its moves are legal.
  List<ChessMove> legalMovesFrom(int row, int col) {
    final piece = board[row][col];
    if (piece == null || piece.color != turn) return const [];
    final pseudo = ChessRules.pseudoLegalMoves(board, row, col, rights: rights, enPassantTarget: enPassantTarget);
    return [for (final m in pseudo) if (!_leavesKingInCheck(m, piece.color)) m];
  }

  List<ChessMove> allLegalMoves(PieceColor color) {
    final moves = <ChessMove>[];
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece == null || piece.color != color) continue;
        final pseudo = ChessRules.pseudoLegalMoves(board, r, c, rights: rights, enPassantTarget: enPassantTarget);
        moves.addAll(pseudo.where((m) => !_leavesKingInCheck(m, color)));
      }
    }
    return moves;
  }

  bool _leavesKingInCheck(ChessMove move, PieceColor color) {
    final clone = _cloneBoard(board);
    _applyMoveToBoard(clone, move);
    final king = ChessRules.findKing(clone, color);
    if (king == null) return true;
    return ChessRules.isSquareAttacked(clone, king.$1, king.$2, color.opposite);
  }

  /// Applies [move] to the real game and refreshes turn/rights/en-passant/
  /// check status. Assumes [move] came from [legalMovesFrom]/
  /// [allLegalMoves] — not re-validated here.
  void applyMove(ChessMove move) {
    final movingColor = board[move.fromRow][move.fromCol]!.color;

    _applyMoveToBoard(board, move);
    _revokeCastlingRights(move);
    _updateEnPassantTarget(move);

    turn = movingColor.opposite;
    lastMove = move;

    final opponentInCheck = isInCheck(turn);
    final opponentHasMoves = allLegalMoves(turn).isNotEmpty;
    isCheckmate = opponentInCheck && !opponentHasMoves;
    isStalemate = !opponentInCheck && !opponentHasMoves;
  }

  static void _applyMoveToBoard(Board board, ChessMove move) {
    final piece = board[move.fromRow][move.fromCol];
    board[move.fromRow][move.fromCol] = null;

    if (move.isEnPassant) {
      final capturedRow = piece!.color == PieceColor.white ? move.toRow + 1 : move.toRow - 1;
      board[capturedRow][move.toCol] = null;
    }

    board[move.toRow][move.toCol] = move.promotion != null ? ChessPiece(move.promotion!, piece!.color) : piece;

    if (move.isCastle) {
      final bool kingSide = move.toCol > move.fromCol;
      final int rookFromCol = kingSide ? 7 : 0;
      final int rookToCol = kingSide ? move.toCol - 1 : move.toCol + 1;
      board[move.fromRow][rookToCol] = board[move.fromRow][rookFromCol];
      board[move.fromRow][rookFromCol] = null;
    }
  }

  void _revokeCastlingRights(ChessMove move) {
    final movedPiece = board[move.toRow][move.toCol];
    if (movedPiece?.type == PieceType.king) {
      rights = movedPiece!.color == PieceColor.white
          ? rights.copyWith(whiteKingSide: false, whiteQueenSide: false)
          : rights.copyWith(blackKingSide: false, blackQueenSide: false);
    }
    // A rook moving away from, or being captured on, its home square
    // revokes that side's right — checking both move endpoints covers both.
    for (final (row, col) in [(move.fromRow, move.fromCol), (move.toRow, move.toCol)]) {
      if (row == 7 && col == 0) rights = rights.copyWith(whiteQueenSide: false);
      if (row == 7 && col == 7) rights = rights.copyWith(whiteKingSide: false);
      if (row == 0 && col == 0) rights = rights.copyWith(blackQueenSide: false);
      if (row == 0 && col == 7) rights = rights.copyWith(blackKingSide: false);
    }
  }

  void _updateEnPassantTarget(ChessMove move) {
    final piece = board[move.toRow][move.toCol];
    final bool wasDoubleStep = piece?.type == PieceType.pawn && (move.toRow - move.fromRow).abs() == 2;
    enPassantTarget = wasDoubleStep ? ((move.fromRow + move.toRow) ~/ 2, move.toCol) : null;
  }

  static Board _cloneBoard(Board board) => [for (final row in board) [...row]];
}
