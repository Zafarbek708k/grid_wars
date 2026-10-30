import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';

part 'bubble_shooter_state.dart';

/// Score/pause/game-over state for one Bubble Shooter run. The grid rules
/// live in [BubbleShooterEngine] (Flame-free, unit-tested); this cubit only
/// mirrors what the UI needs and persists the best score — the same
/// lighter pattern Snake/Tetris use, not Ocean Sweep's bespoke leaderboard.
class BubbleShooterCubit extends Cubit<BubbleShooterState> {
  BubbleShooterCubit() : super(BubbleShooterState(best: StorageRepository.getInt(_bestScoreKey, defValue: 0)));

  static const String _bestScoreKey = 'bubble_shooter_best_score';

  /// Called by [BubbleShooterGame] after every shot that lands — a no-op
  /// once the run has already ended.
  void sync({required int score, required String current, required String next}) {
    if (state.isGameOver) return;
    emit(state.copyWith(score: score, current: current, next: next));
  }

  void pause() {
    if (!state.isGameOver) emit(state.copyWith(isPaused: true));
  }

  void resume() {
    if (!state.isGameOver) emit(state.copyWith(isPaused: false));
  }

  Future<void> gameOver({required int score, required bool won}) async {
    final int newBest = max(state.best, score);
    if (newBest != state.best) {
      await StorageRepository.putInt(_bestScoreKey, newBest);
    }
    unawaited(DailyChallengeService.notifyGameCompleted('bubbleShooter'));
    unawaited(GameStatsService.recordCompletion('bubbleShooter', value: score));
    emit(state.copyWith(score: score, isGameOver: true, isWin: won, best: newBest, isPaused: false));
  }

  void reset() => emit(BubbleShooterState(best: state.best));
}
