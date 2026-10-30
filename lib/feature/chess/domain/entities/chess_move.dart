import 'package:equatable/equatable.dart';

import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';

class ChessMove extends Equatable {
  const ChessMove({
    required this.fromRow,
    required this.fromCol,
    required this.toRow,
    required this.toCol,
    this.promotion,
    this.isCastle = false,
    this.isEnPassant = false,
  });

  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;

  /// Always queen when set — underpromotion choice isn't offered.
  final PieceType? promotion;
  final bool isCastle;
  final bool isEnPassant;

  @override
  List<Object?> get props => [fromRow, fromCol, toRow, toCol, promotion, isCastle, isEnPassant];
}
