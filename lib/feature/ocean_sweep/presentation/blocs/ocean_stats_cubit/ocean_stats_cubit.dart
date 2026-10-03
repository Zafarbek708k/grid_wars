import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';
import 'package:grid_wars/feature/ocean_sweep/domain/entities/score_entry.dart';
import 'package:grid_wars/feature/ocean_sweep/domain/services/ocean_sweep_service.dart';

part 'ocean_stats_state.dart';

/// Owns everything persisted across runs: nickname, high score, the top-10
/// leaderboard, and the sound/vibration toggles. Reads/writes go through
/// [OceanSweepService] (the shared StorageRepository), same as every other
/// game's stats.
class OceanStatsCubit extends Cubit<OceanStatsState> {
  OceanStatsCubit() : super(const OceanStatsState());

  void load() {
    emit(
      OceanStatsState(
        nickname: OceanSweepService.nickname,
        highScore: OceanSweepService.highScore,
        leaderboard: OceanSweepService.leaderboard,
        soundEnabled: OceanSweepService.soundEnabled,
        vibrationEnabled: OceanSweepService.vibrationEnabled,
      ),
    );
  }

  Future<void> saveNickname(String nickname) async {
    final String value = nickname.trim();
    if (value.isEmpty) return;
    await OceanSweepService.saveNickname(value);
    emit(state.copyWith(nickname: value));
  }

  Future<void> submitScore(int score) async {
    final bool isNew = await OceanSweepService.submitScore(
      ScoreEntry(nickname: state.nickname, score: score, playedAt: DateTime.now()),
    );

    if (score > 0) {
      unawaited(DailyChallengeService.notifyGameCompleted('oceanSweep'));
      unawaited(GameStatsService.recordCompletion('oceanSweep', value: score));
    }

    emit(
      state.copyWith(
        highScore: OceanSweepService.highScore,
        leaderboard: OceanSweepService.leaderboard,
        lastIsNewHighScore: isNew,
      ),
    );
  }

  Future<void> toggleSound() async {
    final bool value = !state.soundEnabled;
    await OceanSweepService.setSoundEnabled(value);
    emit(state.copyWith(soundEnabled: value));
  }

  Future<void> toggleVibration() async {
    final bool value = !state.vibrationEnabled;
    await OceanSweepService.setVibrationEnabled(value);
    emit(state.copyWith(vibrationEnabled: value));
  }
}
