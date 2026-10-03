part of 'x_o_bloc.dart';

class XOState extends Equatable {
  final List<GameItemTypeEnum> board;
  final GameItemTypeEnum currentPlayer;
  final String? winner;
  final bool isGameOver;
  final List<int> winningLine;
  final GameMode mode;
  final BotDifficulty botDifficulty;

  const XOState({
    this.board = const [
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
    ],
    this.currentPlayer = GameItemTypeEnum.x,
    this.winner,
    this.isGameOver = false,
    this.winningLine = const [],
    this.mode = GameMode.friend,
    this.botDifficulty = BotDifficulty.hard,
  });

  /// In bot mode, the bot always plays O — this is true while it's the
  /// bot's turn and human taps on the board should be ignored.
  bool get isBotTurn => mode == GameMode.bot && currentPlayer.isO;

  XOState copyWith({
    List<GameItemTypeEnum>? board,
    GameItemTypeEnum? currentPlayer,
    String? winner,
    bool? isGameOver,
    List<int>? winningLine,
    GameMode? mode,
    BotDifficulty? botDifficulty,
  }) {
    return XOState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      winner: winner ?? this.winner,
      isGameOver: isGameOver ?? this.isGameOver,
      winningLine: winningLine ?? this.winningLine,
      mode: mode ?? this.mode,
      botDifficulty: botDifficulty ?? this.botDifficulty,
    );
  }

  @override
  List<Object?> get props => [board, currentPlayer, winner, isGameOver, winningLine, mode, botDifficulty];
}
