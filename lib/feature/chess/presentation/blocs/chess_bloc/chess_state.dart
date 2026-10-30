part of 'chess_bloc.dart';

class ChessState extends Equatable {
  const ChessState({
    required this.board,
    this.turn = PieceColor.white,
    this.mode = GameMode.friend,
    this.botDifficulty = BotDifficulty.easy,
    this.selected,
    this.legalMoves = const [],
    this.isCheck = false,
    this.isCheckmate = false,
    this.isStalemate = false,
    this.lastMove,
  });

  final Board board;
  final PieceColor turn;
  final GameMode mode;
  final BotDifficulty botDifficulty;
  final (int, int)? selected;
  final List<ChessMove> legalMoves;
  final bool isCheck;
  final bool isCheckmate;
  final bool isStalemate;
  final ChessMove? lastMove;

  bool get isGameOver => isCheckmate || isStalemate;

  bool get isBotTurn => mode == GameMode.bot && turn == PieceColor.black;

  /// The side that just won by checkmate, or null if the game isn't over
  /// or ended in a stalemate draw.
  PieceColor? get winner => isCheckmate ? turn.opposite : null;

  ChessState copyWith({GameMode? mode, BotDifficulty? botDifficulty}) {
    return ChessState(
      board: board,
      turn: turn,
      mode: mode ?? this.mode,
      botDifficulty: botDifficulty ?? this.botDifficulty,
      selected: selected,
      legalMoves: legalMoves,
      isCheck: isCheck,
      isCheckmate: isCheckmate,
      isStalemate: isStalemate,
      lastMove: lastMove,
    );
  }

  @override
  List<Object?> get props => [
    board,
    turn,
    mode,
    botDifficulty,
    selected,
    legalMoves,
    isCheck,
    isCheckmate,
    isStalemate,
    lastMove,
  ];
}
