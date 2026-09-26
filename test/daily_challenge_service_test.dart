import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/daily_challenge/domain/entities/daily_challenge_game.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';

String _daysAgo(int days) => DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: days)));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageRepository.getInstance();
  });

  group('DailyChallengeService', () {
    test('todayGame is deterministic across calls', () {
      expect(DailyChallengeService.todayGame.id, DailyChallengeService.todayGame.id);
      expect(dailyChallengeGames.map((g) => g.id), contains(DailyChallengeService.todayGame.id));
    });

    test('completing a game that is not featured today does nothing', () async {
      final String otherGameId = dailyChallengeGames.firstWhere((g) => g.id != DailyChallengeService.todayGame.id).id;

      await DailyChallengeService.notifyGameCompleted(otherGameId);

      expect(DailyChallengeService.isCompletedToday, isFalse);
      expect(DailyChallengeService.currentStreak, 0);
      expect(DailyChallengeService.totalCompleted, 0);
    });

    test('completing today\'s featured game for the first time starts a streak of 1', () async {
      await DailyChallengeService.notifyGameCompleted(DailyChallengeService.todayGame.id);

      expect(DailyChallengeService.isCompletedToday, isTrue);
      expect(DailyChallengeService.currentStreak, 1);
      expect(DailyChallengeService.longestStreak, 1);
      expect(DailyChallengeService.totalCompleted, 1);
    });

    test('completing the same day twice does not double-count', () async {
      final String gameId = DailyChallengeService.todayGame.id;

      await DailyChallengeService.notifyGameCompleted(gameId);
      await DailyChallengeService.notifyGameCompleted(gameId);

      expect(DailyChallengeService.currentStreak, 1);
      expect(DailyChallengeService.totalCompleted, 1);
    });

    test('completing on the day right after a completed day extends the streak', () async {
      await StorageRepository.putString(DailyChallengeService.lastDateKey, _daysAgo(1));
      await StorageRepository.putInt(DailyChallengeService.currentStreakKey, 3);
      await StorageRepository.putInt(DailyChallengeService.longestStreakKey, 3);

      await DailyChallengeService.notifyGameCompleted(DailyChallengeService.todayGame.id);

      expect(DailyChallengeService.currentStreak, 4);
      expect(DailyChallengeService.longestStreak, 4);
    });

    test('a skipped day resets the streak to 1 without lowering the longest streak', () async {
      await StorageRepository.putString(DailyChallengeService.lastDateKey, _daysAgo(2));
      await StorageRepository.putInt(DailyChallengeService.currentStreakKey, 5);
      await StorageRepository.putInt(DailyChallengeService.longestStreakKey, 5);

      await DailyChallengeService.notifyGameCompleted(DailyChallengeService.todayGame.id);

      expect(DailyChallengeService.currentStreak, 1);
      expect(DailyChallengeService.longestStreak, 5);
    });

    test('lastSevenDays reflects today only right after completing', () async {
      await DailyChallengeService.notifyGameCompleted(DailyChallengeService.todayGame.id);

      final List<bool> last7 = DailyChallengeService.lastSevenDays();
      expect(last7.length, 7);
      expect(last7.last, isTrue); // today
      expect(last7.take(6), everyElement(isFalse));
    });
  });
}
