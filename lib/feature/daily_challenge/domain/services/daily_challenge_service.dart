import 'package:intl/intl.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/daily_challenge/domain/entities/daily_challenge_game.dart';

/// Tracks the Daily Challenge streak in [StorageRepository]. Today's
/// featured game is a pure function of the date (no storage needed); a
/// game "counts" only if it's the one featured today, and only once per
/// calendar day.
///
/// The storage keys below are public (not test-only) so tests can seed a
/// prior day's completion to exercise the streak/reset logic directly.
class DailyChallengeService {
  DailyChallengeService._();

  static const String lastDateKey = 'daily_challenge_last_date';
  static const String currentStreakKey = 'daily_challenge_current_streak';
  static const String longestStreakKey = 'daily_challenge_longest_streak';
  static const String _totalCompletedKey = 'daily_challenge_total_completed';
  static const String _historyKey = 'daily_challenge_history';

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static String _format(DateTime date) => _dateFormat.format(date);

  static String get _today => _format(DateTime.now());

  static String get _yesterday => _format(DateTime.now().subtract(const Duration(days: 1)));

  static DailyChallengeGame get todayGame {
    final DateTime now = DateTime.now();
    final int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return dailyChallengeGames[dayOfYear % dailyChallengeGames.length];
  }

  static bool get isCompletedToday => StorageRepository.getString(lastDateKey) == _today;

  static int get currentStreak => StorageRepository.getInt(currentStreakKey, defValue: 0);

  static int get longestStreak => StorageRepository.getInt(longestStreakKey, defValue: 0);

  static int get totalCompleted => StorageRepository.getInt(_totalCompletedKey, defValue: 0);

  /// The last 7 calendar days (oldest first, today last) and whether each
  /// one had a completed challenge.
  static List<bool> lastSevenDays() {
    final Set<String> history = StorageRepository.getList(_historyKey).toSet();
    final DateTime now = DateTime.now();
    return List.generate(7, (i) => history.contains(_format(now.subtract(Duration(days: 6 - i)))));
  }

  /// Call whenever any game reaches its win state. No-ops unless [gameId]
  /// is today's featured game and today hasn't already been credited.
  static Future<void> notifyGameCompleted(String gameId) async {
    if (gameId != todayGame.id || isCompletedToday) return;

    final bool continuesStreak = StorageRepository.getString(lastDateKey) == _yesterday;
    final int newStreak = continuesStreak ? currentStreak + 1 : 1;
    final int newLongest = newStreak > longestStreak ? newStreak : longestStreak;

    final List<String> history = [...StorageRepository.getList(_historyKey), _today];
    final List<String> trimmedHistory = history.length > 14 ? history.sublist(history.length - 14) : history;

    await StorageRepository.putString(lastDateKey, _today);
    await StorageRepository.putInt(currentStreakKey, newStreak);
    await StorageRepository.putInt(longestStreakKey, newLongest);
    await StorageRepository.putInt(_totalCompletedKey, totalCompleted + 1);
    await StorageRepository.putList(_historyKey, trimmedHistory);
  }
}
