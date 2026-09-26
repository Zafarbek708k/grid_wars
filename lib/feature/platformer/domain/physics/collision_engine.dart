import 'package:flutter/material.dart';

/// Collision helpers implementing robust AABB (Axis-Aligned Bounding Box) resolution.
class CollisionEngine {
  CollisionEngine._();

  /// Basic AABB rectangle overlap
  static bool isColliding(Rect a, Rect b) {
    return a.overlaps(b);
  }

  /// Check whether the player is landing downward onto the top surface of a platform.
  /// Uses previous and current vertical bounds to ensure stable landing without sinking or tunneling.
  static bool isLandingOnTop({
    required Rect player,
    required Rect platform,
    required double previousBottom,
    required double velocityY,
    double snapTolerance = 8.0,
  }) {
    // Must be moving downward
    if (velocityY < 0) return false;

    // Horizontal overlap check
    final bool horizontalOverlap = player.right > platform.left + 4 && player.left < platform.right - 4;
    if (!horizontalOverlap) return false;

    // Was above (or just at) the platform surface in previous frame
    final bool wasAbove = previousBottom <= platform.top + snapTolerance;

    // Currently at or below platform surface
    final bool isAtOrBelow = player.bottom >= platform.top - snapTolerance;

    return wasAbove && isAtOrBelow;
  }

  /// Check whether player jumped into the bottom of a block
  static bool isHittingFromBelow({
    required Rect player,
    required Rect block,
    required double previousTop,
    required double velocityY,
    double tolerance = 8.0,
  }) {
    // Must be moving upward
    if (velocityY >= 0) return false;

    // Horizontal overlap
    final bool horizontalOverlap = player.right > block.left + 4 && player.left < block.right - 4;
    if (!horizontalOverlap) return false;

    // Was below block bottom, now penetrating block bottom
    final bool wasBelow = previousTop >= block.bottom - tolerance;
    final bool isAtOrAbove = player.top <= block.bottom + tolerance;

    return wasBelow && isAtOrAbove;
  }
}
