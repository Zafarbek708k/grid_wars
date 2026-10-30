import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/bubble_shooter/presentation/blocs/bubble_shooter_cubit/bubble_shooter_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageRepository.getInstance();
    // StorageRepository caches its SharedPreferences instance as a
    // process-wide singleton that only initializes once, so
    // setMockInitialValues above doesn't actually clear state left behind
    // by an earlier test in this file once that instance already exists.
    await StorageRepository.deleteInt('bubble_shooter_best_score');
  });

  group('BubbleShooterCubit', () {
    test('starts at score 0 with the persisted best score (0 if none saved)', () {
      final cubit = BubbleShooterCubit();
      expect(cubit.state.score, 0);
      expect(cubit.state.best, 0);
      expect(cubit.state.isGameOver, isFalse);
      cubit.close();
    });

    test('sync mirrors score/current/next while the run is active', () {
      final cubit = BubbleShooterCubit();
      cubit.sync(score: 120, current: 'red', next: 'blue');
      expect(cubit.state.score, 120);
      expect(cubit.state.current, 'red');
      expect(cubit.state.next, 'blue');
      cubit.close();
    });

    test('pause/resume toggle isPaused while the run is active', () {
      final cubit = BubbleShooterCubit();
      cubit.pause();
      expect(cubit.state.isPaused, isTrue);
      cubit.resume();
      expect(cubit.state.isPaused, isFalse);
      cubit.close();
    });

    test('gameOver on a win raises best and sets isWin', () async {
      final cubit = BubbleShooterCubit();
      await cubit.gameOver(score: 500, won: true);

      expect(cubit.state.isGameOver, isTrue);
      expect(cubit.state.isWin, isTrue);
      expect(cubit.state.best, 500);
      expect(StorageRepository.getInt('bubble_shooter_best_score'), 500);
      cubit.close();
    });

    test('gameOver on a loss does not set isWin', () async {
      final cubit = BubbleShooterCubit();
      await cubit.gameOver(score: 80, won: false);

      expect(cubit.state.isGameOver, isTrue);
      expect(cubit.state.isWin, isFalse);
      cubit.close();
    });

    test('gameOver does not lower best on a worse run', () async {
      await StorageRepository.putInt('bubble_shooter_best_score', 1000);
      final cubit = BubbleShooterCubit();
      await cubit.gameOver(score: 200, won: false);

      expect(cubit.state.best, 1000);
      cubit.close();
    });

    test('sync is ignored once the run has ended', () async {
      final cubit = BubbleShooterCubit();
      await cubit.gameOver(score: 300, won: false);
      cubit.sync(score: 999, current: 'purple', next: 'green');

      expect(cubit.state.score, 300);
      cubit.close();
    });

    test('reset starts a fresh run but keeps the best score', () async {
      final cubit = BubbleShooterCubit();
      await cubit.gameOver(score: 300, won: false);
      cubit.reset();

      expect(cubit.state.score, 0);
      expect(cubit.state.isGameOver, isFalse);
      expect(cubit.state.best, 300);
      cubit.close();
    });
  });
}
