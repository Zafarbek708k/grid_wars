import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';

part 'snake_state.dart';

/// Score/pause/game-over state for one Snake run. The grid logic itself
/// lives in [SnakeEngine] (Flame-free, unit-tested); this cubit only tracks
/// what the UI needs to react to and persists the best score — the same
/// lighter pattern 2048 uses, not Ocean Sweep's bespoke leaderboard.
class SnakeCubit extends Cubit<SnakeState> {
  SnakeCubit() : super(SnakeState(best: StorageRepository.getInt(_bestScoreKey, defValue: 0)));

  static const String _bestScoreKey = 'snake_best_score';

  void eat() => emit(state.copyWith(score: state.score + 1));

  void pause() {
    if (!state.isGameOver) emit(state.copyWith(isPaused: true));
  }

  void resume() {
    if (!state.isGameOver) emit(state.copyWith(isPaused: false));
  }

  Future<void> gameOver() async {
    final int newBest = max(state.best, state.score);
    if (newBest != state.best) {
      await StorageRepository.putInt(_bestScoreKey, newBest);
    }
    unawaited(DailyChallengeService.notifyGameCompleted('snake'));
    unawaited(GameStatsService.recordCompletion('snake', value: state.score));
    emit(state.copyWith(isGameOver: true, best: newBest, isPaused: false));
  }

  void reset() => emit(SnakeState(best: state.best));
}
