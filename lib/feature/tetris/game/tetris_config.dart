import 'dart:math' as math;

/// Balance numbers for Tetris, kept in one place so they can be tuned
/// without touching gameplay code.
class TetrisConfig {
  const TetrisConfig();

  /// Seconds between automatic gravity steps, shortening each level.
  double dropInterval(int level) => math.max(0.1, 0.8 - (level - 1) * 0.06);
}
