import 'dart:math' as math;

/// Balance numbers for Snake, kept in one place so they can be tuned
/// without touching gameplay code.
class SnakeConfig {
  const SnakeConfig();

  double get cellSize => 20;

  /// Seconds between grid steps. Speeds up as the score grows, floored so
  /// it never becomes literally unplayable.
  double stepInterval(int score) => math.max(0.06, 0.16 - score * 0.004);
}
