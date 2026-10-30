import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/tetris/presentation/blocs/tetris_cubit/tetris_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageRepository.getInstance();
    // StorageRepository caches its SharedPreferences instance as a
    // process-wide singleton that only initializes once, so
    // setMockInitialValues above doesn't actually clear state left behind
    // by an earlier test in this file once that instance already exists.
    await StorageRepository.deleteInt('tetris_best_score');
  });

  group('TetrisCubit', () {
    test('starts at score 0 with the persisted best score (0 if none saved)', () {
      final cubit = TetrisCubit();
      expect(cubit.state.score, 0);
      expect(cubit.state.best, 0);
      expect(cubit.state.isGameOver, isFalse);
      cubit.close();
    });

    test('sync mirrors score/level/lines/next while the run is active', () {
      final cubit = TetrisCubit();
      cubit.sync(score: 400, level: 2, lines: 3, next: 'T');
      expect(cubit.state.score, 400);
      expect(cubit.state.level, 2);
      expect(cubit.state.lines, 3);
      expect(cubit.state.next, 'T');
      cubit.close();
    });

    test('pause/resume toggle isPaused while the run is active', () {
      final cubit = TetrisCubit();
      cubit.pause();
      expect(cubit.state.isPaused, isTrue);
      cubit.resume();
      expect(cubit.state.isPaused, isFalse);
      cubit.close();
    });

    test('gameOver raises best when the score beats it and persists it', () async {
      final cubit = TetrisCubit();
      await cubit.gameOver(score: 500);

      expect(cubit.state.isGameOver, isTrue);
      expect(cubit.state.best, 500);
      expect(StorageRepository.getInt('tetris_best_score'), 500);
      cubit.close();
    });

    test('gameOver does not lower best on a worse run', () async {
      await StorageRepository.putInt('tetris_best_score', 1000);
      final cubit = TetrisCubit();
      await cubit.gameOver(score: 200);

      expect(cubit.state.best, 1000);
      cubit.close();
    });

    test('sync is ignored once the run has ended', () async {
      final cubit = TetrisCubit();
      await cubit.gameOver(score: 300);
      cubit.sync(score: 999, level: 9, lines: 9, next: 'I');

      expect(cubit.state.score, 300);
      cubit.close();
    });

    test('reset starts a fresh run but keeps the best score', () async {
      final cubit = TetrisCubit();
      await cubit.gameOver(score: 300);
      cubit.reset();

      expect(cubit.state.score, 0);
      expect(cubit.state.isGameOver, isFalse);
      expect(cubit.state.best, 300);
      cubit.close();
    });
  });
}
