import 'package:intl/intl.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/game_stats/domain/entities/game_stat_snapshot.dart';

/// Per-game play history, persisted in [StorageRepository]: a running
/// completion count, when it was last played, and (for games that report
/// one) the best value ever reached.
class GameStatsService {
  GameStatsService._();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static String _timesKey(String gameId) => 'game_stats_${gameId}_times';

  static String _lastPlayedKey(String gameId) => 'game_stats_${gameId}_last_played';

  static String _bestKey(String gameId) => 'game_stats_${gameId}_best';

  /// Call whenever [gameId] finishes a play worth counting (a win, a solve,
  /// a completed round). [value], if given, is compared against the stored
  /// best using [lowerIsBetter] and kept only if it's an improvement.
  static Future<void> recordCompletion(String gameId, {int? value, bool lowerIsBetter = false}) async {
    await StorageRepository.putInt(_timesKey(gameId), StorageRepository.getInt(_timesKey(gameId), defValue: 0) + 1);
    await StorageRepository.putString(_lastPlayedKey(gameId), _dateFormat.format(DateTime.now()));

    if (value == null) return;

    final int currentBest = StorageRepository.getInt(_bestKey(gameId), defValue: -1);
    final bool isNewBest = currentBest == -1 || (lowerIsBetter ? value < currentBest : value > currentBest);
    if (isNewBest) {
      await StorageRepository.putInt(_bestKey(gameId), value);
    }
  }

  static GameStatSnapshot getStats(String gameId) {
    final int times = StorageRepository.getInt(_timesKey(gameId), defValue: 0);
    final String lastPlayedRaw = StorageRepository.getString(_lastPlayedKey(gameId));
    final int best = StorageRepository.getInt(_bestKey(gameId), defValue: -1);

    return GameStatSnapshot(
      timesCompleted: times,
      bestValue: best == -1 ? null : best,
      lastPlayed: lastPlayedRaw.isEmpty ? null : DateTime.tryParse(lastPlayedRaw),
    );
  }
}
