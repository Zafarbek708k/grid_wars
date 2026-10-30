part of 'snake_cubit.dart';

class SnakeState extends Equatable {
  const SnakeState({this.score = 0, this.best = 0, this.isGameOver = false, this.isPaused = false});

  final int score;
  final int best;
  final bool isGameOver;
  final bool isPaused;

  SnakeState copyWith({int? score, int? best, bool? isGameOver, bool? isPaused}) {
    return SnakeState(
      score: score ?? this.score,
      best: best ?? this.best,
      isGameOver: isGameOver ?? this.isGameOver,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object?> get props => [score, best, isGameOver, isPaused];
}
