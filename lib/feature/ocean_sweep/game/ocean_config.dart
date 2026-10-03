import 'dart:math' as math;

/// Balance numbers for Ocean Sweep. Kept in one place so they can be
/// tuned without touching gameplay code.
class OceanConfig {
  const OceanConfig();

  static const List<double> _speeds = [140, 180, 220, 260, 300]; // px/s, one per level

  double speedForLevel(int level) {
    final int i = math.min(math.max(level - 1, 0), _speeds.length - 1);
    return _speeds[i];
  }

  double get trashInterval => 1.1;

  double get boosterInterval => 15;

  double get shieldDuration => 5;

  double enemyInterval(int level) => math.max(1.0, 2.4 - (level - 1) * 0.2);
}
