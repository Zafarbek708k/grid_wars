import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageRepository.getInstance();
  });

  group('GameStatsService', () {
    test('an unplayed game reports zero completions and no best value', () {
      final stats = GameStatsService.getStats('neverPlayed');

      expect(stats.timesCompleted, 0);
      expect(stats.bestValue, isNull);
      expect(stats.lastPlayed, isNull);
      expect(stats.hasEverPlayed, isFalse);
    });

    test('recording a completion without a value only bumps the play count', () async {
      await GameStatsService.recordCompletion('wordSearch');
      await GameStatsService.recordCompletion('wordSearch');

      final stats = GameStatsService.getStats('wordSearch');
      expect(stats.timesCompleted, 2);
      expect(stats.bestValue, isNull);
      expect(stats.lastPlayed, isNotNull);
    });

    test('higher-is-better keeps the maximum value seen', () async {
      await GameStatsService.recordCompletion('game2048', value: 512);
      await GameStatsService.recordCompletion('game2048', value: 256);
      await GameStatsService.recordCompletion('game2048', value: 1024);

      final stats = GameStatsService.getStats('game2048');
      expect(stats.timesCompleted, 3);
      expect(stats.bestValue, 1024);
    });

    test('lower-is-better keeps the minimum value seen', () async {
      await GameStatsService.recordCompletion('fifteenPuzzle', value: 80, lowerIsBetter: true);
      await GameStatsService.recordCompletion('fifteenPuzzle', value: 40, lowerIsBetter: true);
      await GameStatsService.recordCompletion('fifteenPuzzle', value: 60, lowerIsBetter: true);

      final stats = GameStatsService.getStats('fifteenPuzzle');
      expect(stats.timesCompleted, 3);
      expect(stats.bestValue, 40);
    });

    test('a value of exactly 0 is tracked correctly, not treated as unset', () async {
      await GameStatsService.recordCompletion('sudoku', value: 0, lowerIsBetter: true);

      final stats = GameStatsService.getStats('sudoku');
      expect(stats.bestValue, 0);

      await GameStatsService.recordCompletion('sudoku', value: 2, lowerIsBetter: true);
      expect(GameStatsService.getStats('sudoku').bestValue, 0);
    });

    test('stats for different game ids are independent', () async {
      await GameStatsService.recordCompletion('ticTacToe', value: 5);
      await GameStatsService.recordCompletion('minesweeper', value: 3);

      expect(GameStatsService.getStats('ticTacToe').bestValue, 5);
      expect(GameStatsService.getStats('minesweeper').bestValue, 3);
    });
  });
}
