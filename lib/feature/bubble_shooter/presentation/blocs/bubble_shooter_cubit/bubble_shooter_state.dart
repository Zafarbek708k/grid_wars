part of 'bubble_shooter_cubit.dart';

class BubbleShooterState extends Equatable {
  const BubbleShooterState({
    this.score = 0,
    this.best = 0,
    this.current = '',
    this.next = '',
    this.isGameOver = false,
    this.isWin = false,
    this.isPaused = false,
  });

  final int score;
  final int best;
  final String current;
  final String next;
  final bool isGameOver;
  final bool isWin;
  final bool isPaused;

  BubbleShooterState copyWith({
    int? score,
    int? best,
    String? current,
    String? next,
    bool? isGameOver,
    bool? isWin,
    bool? isPaused,
  }) {
    return BubbleShooterState(
      score: score ?? this.score,
      best: best ?? this.best,
      current: current ?? this.current,
      next: next ?? this.next,
      isGameOver: isGameOver ?? this.isGameOver,
      isWin: isWin ?? this.isWin,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object?> get props => [score, best, current, next, isGameOver, isWin, isPaused];
}
