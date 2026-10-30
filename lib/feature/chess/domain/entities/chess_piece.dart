import 'package:equatable/equatable.dart';

enum PieceType { pawn, knight, bishop, rook, queen, king }

enum PieceColor { white, black }

extension PieceColorX on PieceColor {
  PieceColor get opposite => this == PieceColor.white ? PieceColor.black : PieceColor.white;
}

class ChessPiece extends Equatable {
  const ChessPiece(this.type, this.color);

  final PieceType type;
  final PieceColor color;

  @override
  List<Object?> get props => [type, color];
}
