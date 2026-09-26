part of 'game2048_bloc.dart';

class Game2048State extends Equatable {
  final List<List<int>> board;
  final int score;
  final int best;
  final bool isGameOver;
  final bool hasWon;

  const Game2048State({
    this.board = const [],
    this.score = 0,
    this.best = 0,
    this.isGameOver = false,
    this.hasWon = false,
  });

  Game2048State copyWith({
    List<List<int>>? board,
    int? score,
    int? best,
    bool? isGameOver,
    bool? hasWon,
  }) {
    return Game2048State(
      board: board ?? this.board,
      score: score ?? this.score,
      best: best ?? this.best,
      isGameOver: isGameOver ?? this.isGameOver,
      hasWon: hasWon ?? this.hasWon,
    );
  }

  @override
  List<Object?> get props => [board, score, best, isGameOver, hasWon];
}
