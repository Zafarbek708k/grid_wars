import 'package:grid_wars/feature/chess/domain/entities/castling_rights.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_move.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';

typedef Board = List<List<ChessPiece?>>;

/// Pure move-generation and attack-detection for chess — no Flutter/Bloc
/// dependency, directly unit-testable. Operates on a board snapshot passed
/// in by the caller rather than holding state itself; [ChessEngine] owns
/// the actual game (turn, castling rights, history) and calls into this.
///
/// Generated moves are "pseudo-legal": they follow each piece's movement
/// rules and castling's path/attacked-square checks, but do NOT verify the
/// move leaves the mover's own king safe — that filter lives in
/// [ChessEngine], since it requires simulating the move first.
abstract class ChessRules {
  static const List<(int, int)> _knightOffsets = [
    (-2, -1), (-2, 1), (-1, -2), (-1, 2),
    (1, -2), (1, 2), (2, -1), (2, 1),
  ];
  static const List<(int, int)> _diagonals = [(-1, -1), (-1, 1), (1, -1), (1, 1)];
  static const List<(int, int)> _orthogonals = [(-1, 0), (1, 0), (0, -1), (0, 1)];

  static bool _inBounds(int row, int col) => row >= 0 && row < 8 && col >= 0 && col < 8;

  static (int, int)? findKing(Board board, PieceColor color) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece != null && piece.type == PieceType.king && piece.color == color) return (r, c);
      }
    }
    return null;
  }

  static bool isSquareAttacked(Board board, int row, int col, PieceColor byColor) {
    final int pawnRow = byColor == PieceColor.white ? row + 1 : row - 1;
    for (final dc in [-1, 1]) {
      if (!_inBounds(pawnRow, col + dc)) continue;
      final piece = board[pawnRow][col + dc];
      if (piece != null && piece.type == PieceType.pawn && piece.color == byColor) return true;
    }

    for (final (dr, dc) in _knightOffsets) {
      final r = row + dr, c = col + dc;
      if (!_inBounds(r, c)) continue;
      final piece = board[r][c];
      if (piece != null && piece.type == PieceType.knight && piece.color == byColor) return true;
    }

    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final r = row + dr, c = col + dc;
        if (!_inBounds(r, c)) continue;
        final piece = board[r][c];
        if (piece != null && piece.type == PieceType.king && piece.color == byColor) return true;
      }
    }

    if (_attackedBySlider(board, row, col, byColor, _diagonals, {PieceType.bishop, PieceType.queen})) return true;
    if (_attackedBySlider(board, row, col, byColor, _orthogonals, {PieceType.rook, PieceType.queen})) return true;
    return false;
  }

  static bool _attackedBySlider(
    Board board,
    int row,
    int col,
    PieceColor byColor,
    List<(int, int)> directions,
    Set<PieceType> types,
  ) {
    for (final (dr, dc) in directions) {
      int r = row + dr, c = col + dc;
      while (_inBounds(r, c)) {
        final piece = board[r][c];
        if (piece != null) {
          if (piece.color == byColor && types.contains(piece.type)) return true;
          break;
        }
        r += dr;
        c += dc;
      }
    }
    return false;
  }

  static List<ChessMove> pseudoLegalMoves(
    Board board,
    int row,
    int col, {
    required CastlingRights rights,
    required (int, int)? enPassantTarget,
  }) {
    final piece = board[row][col];
    if (piece == null) return const [];
    return switch (piece.type) {
      PieceType.pawn => _pawnMoves(board, row, col, piece.color, enPassantTarget),
      PieceType.knight => _knightMoves(board, row, col, piece.color),
      PieceType.bishop => _slidingMoves(board, row, col, piece.color, _diagonals),
      PieceType.rook => _slidingMoves(board, row, col, piece.color, _orthogonals),
      PieceType.queen => _slidingMoves(board, row, col, piece.color, [..._diagonals, ..._orthogonals]),
      PieceType.king => _kingMoves(board, row, col, piece.color, rights),
    };
  }

  static List<ChessMove> _pawnMoves(Board board, int row, int col, PieceColor color, (int, int)? enPassantTarget) {
    final moves = <ChessMove>[];
    final int dir = color == PieceColor.white ? -1 : 1;
    final int startRow = color == PieceColor.white ? 6 : 1;
    final int promoteRow = color == PieceColor.white ? 0 : 7;
    final int r1 = row + dir;

    if (_inBounds(r1, col) && board[r1][col] == null) {
      _addPawnMove(moves, row, col, r1, col, promoteRow);
      final int r2 = row + 2 * dir;
      if (row == startRow && board[r2][col] == null) {
        moves.add(ChessMove(fromRow: row, fromCol: col, toRow: r2, toCol: col));
      }
    }

    for (final dc in [-1, 1]) {
      final int c = col + dc;
      if (!_inBounds(r1, c)) continue;
      final target = board[r1][c];
      if (target != null && target.color != color) {
        _addPawnMove(moves, row, col, r1, c, promoteRow);
      } else if (target == null && enPassantTarget == (r1, c)) {
        moves.add(ChessMove(fromRow: row, fromCol: col, toRow: r1, toCol: c, isEnPassant: true));
      }
    }
    return moves;
  }

  static void _addPawnMove(List<ChessMove> moves, int fromRow, int fromCol, int toRow, int toCol, int promoteRow) {
    moves.add(
      ChessMove(
        fromRow: fromRow,
        fromCol: fromCol,
        toRow: toRow,
        toCol: toCol,
        promotion: toRow == promoteRow ? PieceType.queen : null,
      ),
    );
  }

  static List<ChessMove> _knightMoves(Board board, int row, int col, PieceColor color) {
    final moves = <ChessMove>[];
    for (final (dr, dc) in _knightOffsets) {
      final r = row + dr, c = col + dc;
      if (!_inBounds(r, c)) continue;
      final target = board[r][c];
      if (target == null || target.color != color) {
        moves.add(ChessMove(fromRow: row, fromCol: col, toRow: r, toCol: c));
      }
    }
    return moves;
  }

  static List<ChessMove> _slidingMoves(Board board, int row, int col, PieceColor color, List<(int, int)> directions) {
    final moves = <ChessMove>[];
    for (final (dr, dc) in directions) {
      int r = row + dr, c = col + dc;
      while (_inBounds(r, c)) {
        final target = board[r][c];
        if (target == null) {
          moves.add(ChessMove(fromRow: row, fromCol: col, toRow: r, toCol: c));
        } else {
          if (target.color != color) moves.add(ChessMove(fromRow: row, fromCol: col, toRow: r, toCol: c));
          break;
        }
        r += dr;
        c += dc;
      }
    }
    return moves;
  }

  static List<ChessMove> _kingMoves(Board board, int row, int col, PieceColor color, CastlingRights rights) {
    final moves = <ChessMove>[];
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final r = row + dr, c = col + dc;
        if (!_inBounds(r, c)) continue;
        final target = board[r][c];
        if (target == null || target.color != color) {
          moves.add(ChessMove(fromRow: row, fromCol: col, toRow: r, toCol: c));
        }
      }
    }

    final PieceColor enemy = color.opposite;
    if (isSquareAttacked(board, row, col, enemy)) return moves;

    final bool kingSideRight = color == PieceColor.white ? rights.whiteKingSide : rights.blackKingSide;
    final bool queenSideRight = color == PieceColor.white ? rights.whiteQueenSide : rights.blackQueenSide;
    bool hasFriendlyRook(int c) {
      if (!_inBounds(row, c)) return false;
      final piece = board[row][c];
      return piece != null && piece.type == PieceType.rook && piece.color == color;
    }

    if (kingSideRight &&
        hasFriendlyRook(7) &&
        _inBounds(row, col + 2) &&
        board[row][col + 1] == null &&
        board[row][col + 2] == null &&
        !isSquareAttacked(board, row, col + 1, enemy) &&
        !isSquareAttacked(board, row, col + 2, enemy)) {
      moves.add(ChessMove(fromRow: row, fromCol: col, toRow: row, toCol: col + 2, isCastle: true));
    }
    if (queenSideRight &&
        hasFriendlyRook(0) &&
        _inBounds(row, col - 3) &&
        board[row][col - 1] == null &&
        board[row][col - 2] == null &&
        board[row][col - 3] == null &&
        !isSquareAttacked(board, row, col - 1, enemy) &&
        !isSquareAttacked(board, row, col - 2, enemy)) {
      moves.add(ChessMove(fromRow: row, fromCol: col, toRow: row, toCol: col - 2, isCastle: true));
    }
    return moves;
  }
}
