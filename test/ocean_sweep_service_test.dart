import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/ocean_sweep/domain/entities/score_entry.dart';
import 'package:grid_wars/feature/ocean_sweep/domain/services/ocean_sweep_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageRepository.getInstance();
    // StorageRepository caches its SharedPreferences instance as a
    // process-wide singleton that only initializes once, so
    // setMockInitialValues above doesn't actually clear state left behind
    // by an earlier test in this file once that instance already exists.
    // Clear every key this test file touches explicitly instead.
    await StorageRepository.deleteString('ocean_sweep_nickname');
    await StorageRepository.deleteInt('ocean_sweep_high_score');
    await StorageRepository.deleteString('ocean_sweep_leaderboard');
    await StorageRepository.deleteBool('ocean_sweep_sound');
    await StorageRepository.deleteBool('ocean_sweep_vibration');
  });

  group('OceanSweepService', () {
    test('defaults are empty/zero/enabled before anything is saved', () {
      expect(OceanSweepService.nickname, isEmpty);
      expect(OceanSweepService.highScore, 0);
      expect(OceanSweepService.leaderboard, isEmpty);
      expect(OceanSweepService.soundEnabled, isTrue);
      expect(OceanSweepService.vibrationEnabled, isTrue);
    });

    test('nickname is trimmed and persists', () async {
      await OceanSweepService.saveNickname('  Diver  ');
      expect(OceanSweepService.nickname, 'Diver');
    });

    test('a score of 0 or less is rejected', () async {
      final saved = await OceanSweepService.submitScore(
        ScoreEntry(nickname: 'A', score: 0, playedAt: DateTime.now()),
      );
      expect(saved, isFalse);
      expect(OceanSweepService.leaderboard, isEmpty);
    });

    test('submitScore reports a new high score and updates highScore', () async {
      final isNew1 = await OceanSweepService.submitScore(
        ScoreEntry(nickname: 'A', score: 10, playedAt: DateTime.now()),
      );
      expect(isNew1, isTrue);
      expect(OceanSweepService.highScore, 10);

      final isNew2 = await OceanSweepService.submitScore(
        ScoreEntry(nickname: 'B', score: 5, playedAt: DateTime.now()),
      );
      expect(isNew2, isFalse);
      expect(OceanSweepService.highScore, 10);
    });

    test('leaderboard stays sorted descending and capped at 10 entries', () async {
      for (int i = 1; i <= 15; i++) {
        await OceanSweepService.submitScore(
          ScoreEntry(nickname: 'P$i', score: i, playedAt: DateTime.now()),
        );
      }

      final leaderboard = OceanSweepService.leaderboard;
      expect(leaderboard.length, 10);
      expect(leaderboard.first.score, 15);
      expect(leaderboard.last.score, 6);
      for (int i = 0; i < leaderboard.length - 1; i++) {
        expect(leaderboard[i].score, greaterThanOrEqualTo(leaderboard[i + 1].score));
      }
    });

    test('corrupted leaderboard JSON is cleared instead of crashing', () async {
      await StorageRepository.putString('ocean_sweep_leaderboard', 'not valid json {{{');
      expect(OceanSweepService.leaderboard, isEmpty);
      // Confirms the corrupted value was actually cleared, not just ignored.
      expect(StorageRepository.getString('ocean_sweep_leaderboard'), isEmpty);
    });

    test('sound and vibration toggles persist independently', () async {
      await OceanSweepService.setSoundEnabled(false);
      expect(OceanSweepService.soundEnabled, isFalse);
      expect(OceanSweepService.vibrationEnabled, isTrue);

      await OceanSweepService.setVibrationEnabled(false);
      expect(OceanSweepService.vibrationEnabled, isFalse);
    });
  });
}
