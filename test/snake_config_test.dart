import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/snake/game/snake_config.dart';

void main() {
  const config = SnakeConfig();

  group('SnakeConfig', () {
    test('stepInterval shortens as the score grows', () {
      final atZero = config.stepInterval(0);
      final atTen = config.stepInterval(10);
      expect(atTen, lessThan(atZero));
    });

    test('stepInterval never drops below the floor', () {
      expect(config.stepInterval(1000), 0.06);
    });
  });
}
