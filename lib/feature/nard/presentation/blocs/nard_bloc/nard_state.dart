part of 'nard_bloc.dart';

class NardState extends Equatable {
  final int player1Score;
  final int player2Score;
  final int currentPlayer;
  final int dice1;
  final int dice2;
  final bool hasRolled;

  const NardState({
    this.player1Score = 0,
    this.player2Score = 0,
    this.currentPlayer = 1,
    this.dice1 = 1,
    this.dice2 = 1,
    this.hasRolled = false,
  });

  int get lastRollTotal => dice1 + dice2;

  NardState copyWith({
    int? player1Score,
    int? player2Score,
    int? currentPlayer,
    int? dice1,
    int? dice2,
    bool? hasRolled,
  }) {
    return NardState(
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      dice1: dice1 ?? this.dice1,
      dice2: dice2 ?? this.dice2,
      hasRolled: hasRolled ?? this.hasRolled,
    );
  }

  @override
  List<Object?> get props => [player1Score, player2Score, currentPlayer, dice1, dice2, hasRolled];
}
