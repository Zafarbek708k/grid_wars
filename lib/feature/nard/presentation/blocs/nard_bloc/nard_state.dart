part of 'nard_bloc.dart';

class NardState extends Equatable {
  final int player1Score;
  final int player2Score;
  final int currentPlayer;
  final int dice1;
  final int dice2;
  final bool hasRolled;
  final GameMode mode;

  const NardState({
    this.player1Score = 0,
    this.player2Score = 0,
    this.currentPlayer = 1,
    this.dice1 = 1,
    this.dice2 = 1,
    this.hasRolled = false,
    this.mode = GameMode.friend,
  });

  int get lastRollTotal => dice1 + dice2;

  /// Player 2 is always the bot when playing in bot mode.
  bool get isBotTurn => mode == GameMode.bot && currentPlayer == 2;

  NardState copyWith({
    int? player1Score,
    int? player2Score,
    int? currentPlayer,
    int? dice1,
    int? dice2,
    bool? hasRolled,
    GameMode? mode,
  }) {
    return NardState(
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      dice1: dice1 ?? this.dice1,
      dice2: dice2 ?? this.dice2,
      hasRolled: hasRolled ?? this.hasRolled,
      mode: mode ?? this.mode,
    );
  }

  @override
  List<Object?> get props => [player1Score, player2Score, currentPlayer, dice1, dice2, hasRolled, mode];
}
