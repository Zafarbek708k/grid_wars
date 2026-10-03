import 'dart:convert';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/ocean_sweep/domain/entities/score_entry.dart';

/// Ocean Sweep's persistence, backed by the shared [StorageRepository] like
/// every other game's storage (DailyChallengeService, GameStatsService) —
/// no separate repository interface/impl needed for a single static class.
class OceanSweepService {
  OceanSweepService._();

  static const String _nicknameKey = 'ocean_sweep_nickname';
  static const String _highScoreKey = 'ocean_sweep_high_score';
  static const String _leaderboardKey = 'ocean_sweep_leaderboard';
  static const String _soundKey = 'ocean_sweep_sound';
  static const String _vibrationKey = 'ocean_sweep_vibration';
  static const int _maxEntries = 10;

  static String get nickname => StorageRepository.getString(_nicknameKey);

  static Future<void> saveNickname(String nickname) async {
    await StorageRepository.putString(_nicknameKey, nickname.trim());
  }

  static int get highScore => StorageRepository.getInt(_highScoreKey, defValue: 0);

  static List<ScoreEntry> get leaderboard {
    final String raw = StorageRepository.getString(_leaderboardKey);
    if (raw.isEmpty) return const [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => ScoreEntry.fromJson(e as Map<String, dynamic>)).toList();
    } on FormatException {
      // Corrupted data: clear it rather than crash the app on every launch.
      StorageRepository.deleteString(_leaderboardKey);
      return const [];
    }
  }

  /// Adds [entry] to the leaderboard (kept sorted, capped at [_maxEntries]).
  /// Returns true if this is a new high score.
  static Future<bool> submitScore(ScoreEntry entry) async {
    if (entry.score <= 0) return false;

    final List<ScoreEntry> updated = [...leaderboard, entry]..sort((a, b) => b.score.compareTo(a.score));
    final List<Map<String, dynamic>> top = updated.take(_maxEntries).map((e) => e.toJson()).toList();
    await StorageRepository.putString(_leaderboardKey, jsonEncode(top));

    final bool isNewHighScore = entry.score > highScore;
    if (isNewHighScore) {
      await StorageRepository.putInt(_highScoreKey, entry.score);
    }
    return isNewHighScore;
  }

  static bool get soundEnabled => StorageRepository.getBool(_soundKey, defValue: true);

  static Future<void> setSoundEnabled(bool value) async {
    await StorageRepository.putBool(key: _soundKey, value: value);
  }

  static bool get vibrationEnabled => StorageRepository.getBool(_vibrationKey, defValue: true);

  static Future<void> setVibrationEnabled(bool value) async {
    await StorageRepository.putBool(key: _vibrationKey, value: value);
  }
}
