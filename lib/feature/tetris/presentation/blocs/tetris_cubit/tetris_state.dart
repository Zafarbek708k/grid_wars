part of 'tetris_cubit.dart';

class TetrisState extends Equatable {
  const TetrisState({
    this.score = 0,
    this.best = 0,
    this.level = 1,
    this.lines = 0,
    this.next = '',
    this.isGameOver = false,
    this.isPaused = false,
  });

  final int score;
  final int best;
  final int level;
  final int lines;
  final String next;
  final bool isGameOver;
  final bool isPaused;

  TetrisState copyWith({
    int? score,
    int? best,
    int? level,
    int? lines,
    String? next,
    bool? isGameOver,
    bool? isPaused,
  }) {
    return TetrisState(
      score: score ?? this.score,
      best: best ?? this.best,
      level: level ?? this.level,
      lines: lines ?? this.lines,
      next: next ?? this.next,
      isGameOver: isGameOver ?? this.isGameOver,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object?> get props => [score, best, level, lines, next, isGameOver, isPaused];
}
