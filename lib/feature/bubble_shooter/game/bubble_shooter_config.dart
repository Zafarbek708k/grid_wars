/// Balance numbers for Bubble Shooter, kept in one place so they can be
/// tuned without touching gameplay code.
class BubbleShooterConfig {
  const BubbleShooterConfig();

  double get projectileSpeed => 700;

  /// Aim direction is clamped to this many radians off straight-up on
  /// either side, so the player can never fire sideways or downward.
  double get maxAimAngleFromVertical => 1.3;
}
