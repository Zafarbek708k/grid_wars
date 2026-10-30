import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/snake/presentation/blocs/snake_cubit/snake_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageRepository.getInstance();
    // StorageRepository caches its SharedPreferences instance as a
    // process-wide singleton that only initializes once, so
    // setMockInitialValues above doesn't actually clear state left behind
    // by an earlier test in this file once that instance already exists.
    await StorageRepository.deleteInt('snake_best_score');
  });

  group('SnakeCubit', () {
    test('starts at score 0 with the persisted best score (0 if none saved)', () {
      final cubit = SnakeCubit();
      expect(cubit.state.score, 0);
      expect(cubit.state.best, 0);
      expect(cubit.state.isGameOver, isFalse);
      cubit.close();
    });

    test('eat increments score but not best', () {
      final cubit = SnakeCubit();
      cubit.eat();
      cubit.eat();
      expect(cubit.state.score, 2);
      expect(cubit.state.best, 0);
      cubit.close();
    });

    test('pause/resume toggle isPaused while the run is active', () {
      final cubit = SnakeCubit();
      cubit.pause();
      expect(cubit.state.isPaused, isTrue);
      cubit.resume();
      expect(cubit.state.isPaused, isFalse);
      cubit.close();
    });

    test('gameOver raises best when the score beats it and persists it', () async {
      final cubit = SnakeCubit();
      cubit.eat();
      cubit.eat();
      cubit.eat();
      await cubit.gameOver();

      expect(cubit.state.isGameOver, isTrue);
      expect(cubit.state.best, 3);
      expect(StorageRepository.getInt('snake_best_score'), 3);
      cubit.close();
    });

    test('gameOver does not lower best on a worse run', () async {
      await StorageRepository.putInt('snake_best_score', 10);
      final cubit = SnakeCubit();
      cubit.eat();
      await cubit.gameOver();

      expect(cubit.state.best, 10);
      cubit.close();
    });

    test('gameOver while paused clears the paused flag', () async {
      final cubit = SnakeCubit();
      cubit.pause();
      await cubit.gameOver();
      expect(cubit.state.isPaused, isFalse);
      cubit.close();
    });

    test('reset starts a fresh run but keeps the best score', () async {
      final cubit = SnakeCubit();
      cubit.eat();
      cubit.eat();
      await cubit.gameOver();
      cubit.reset();

      expect(cubit.state.score, 0);
      expect(cubit.state.isGameOver, isFalse);
      expect(cubit.state.best, 2);
      cubit.close();
    });
  });
}
