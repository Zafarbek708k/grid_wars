class CastlingRights {
  const CastlingRights({
    this.whiteKingSide = true,
    this.whiteQueenSide = true,
    this.blackKingSide = true,
    this.blackQueenSide = true,
  });

  final bool whiteKingSide;
  final bool whiteQueenSide;
  final bool blackKingSide;
  final bool blackQueenSide;

  CastlingRights copyWith({bool? whiteKingSide, bool? whiteQueenSide, bool? blackKingSide, bool? blackQueenSide}) {
    return CastlingRights(
      whiteKingSide: whiteKingSide ?? this.whiteKingSide,
      whiteQueenSide: whiteQueenSide ?? this.whiteQueenSide,
      blackKingSide: blackKingSide ?? this.blackKingSide,
      blackQueenSide: blackQueenSide ?? this.blackQueenSide,
    );
  }
}
