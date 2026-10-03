import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/ocean_sweep/game/ocean_config.dart';

void main() {
  const config = OceanConfig();

  group('OceanConfig', () {
    test('speedForLevel increases through level 5, then holds steady', () {
      expect(config.speedForLevel(1), 140);
      expect(config.speedForLevel(2), 180);
      expect(config.speedForLevel(5), 300);
      expect(config.speedForLevel(9), 300); // clamped at the last tier
    });

    test('speedForLevel never looks below level 1', () {
      expect(config.speedForLevel(0), config.speedForLevel(1));
      expect(config.speedForLevel(-5), config.speedForLevel(1));
    });

    test('enemyInterval shortens by 0.2s per level, floored at 1.0s', () {
      expect(config.enemyInterval(1), closeTo(2.4, 0.0001));
      expect(config.enemyInterval(2), closeTo(2.2, 0.0001));
      expect(config.enemyInterval(20), 1.0);
    });
  });
}
