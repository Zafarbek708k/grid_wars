import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/tetris/game/tetris_config.dart';

void main() {
  const config = TetrisConfig();

  group('TetrisConfig', () {
    test('dropInterval shortens as the level grows', () {
      final atLevel1 = config.dropInterval(1);
      final atLevel5 = config.dropInterval(5);
      expect(atLevel5, lessThan(atLevel1));
    });

    test('dropInterval never drops below the floor', () {
      expect(config.dropInterval(100), 0.1);
    });
  });
}
