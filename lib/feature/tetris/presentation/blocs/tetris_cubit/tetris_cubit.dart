import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';

part 'tetris_state.dart';

/// Score/level/pause/game-over state for one Tetris run. The grid logic
/// lives in [TetrisEngine] (Flame-free, unit-tested); this cubit only
/// mirrors what the UI needs and persists the best score — the same
/// lighter pattern Snake/2048 use, not Ocean Sweep's bespoke leaderboard.
class TetrisCubit extends Cubit<TetrisState> {
  TetrisCubit() : super(TetrisState(best: StorageRepository.getInt(_bestScoreKey, defValue: 0)));

  static const String _bestScoreKey = 'tetris_best_score';

  /// Called by [TetrisGame] after any action that could change
  /// score/level/lines/next — a no-op once the run has already ended.
  void sync({required int score, required int level, required int lines, required String next}) {
    if (state.isGameOver) return;
    emit(state.copyWith(score: score, level: level, lines: lines, next: next));
  }

  void pause() {
    if (!state.isGameOver) emit(state.copyWith(isPaused: true));
  }

  void resume() {
    if (!state.isGameOver) emit(state.copyWith(isPaused: false));
  }

  Future<void> gameOver({required int score}) async {
    final int newBest = max(state.best, score);
    if (newBest != state.best) {
      await StorageRepository.putInt(_bestScoreKey, newBest);
    }
    unawaited(DailyChallengeService.notifyGameCompleted('tetris'));
    unawaited(GameStatsService.recordCompletion('tetris', value: score));
    emit(state.copyWith(score: score, isGameOver: true, best: newBest, isPaused: false));
  }

  void reset() => emit(TetrisState(best: state.best));
}
