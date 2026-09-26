import 'package:flutter/material.dart';

/// Configuration constants and physics parameters for the 2D Platformer game.
class GameConfig {
  // Prevent instantiation
  GameConfig._();

  /// Reference virtual world dimensions for aspect-ratio mapping
  static const double virtualWorldHeight = 400.0;
  static const double groundHeight = 50.0;

  /// Physics configuration (in pixels per second and pixels per second squared)
  static const double gravity = 1400.0;
  static const double playerSpeed = 260.0;
  static const double jumpForce = 620.0;
  static const double maxFallSpeed = 900.0;

  /// Big (mushroom-grown) Mario moves and jumps farther.
  static const double playerSpeedBig = 300.0;
  static const double jumpForceBig = 720.0;

  /// Player dimensions
  static const double playerSmallWidth = 40.0;
  static const double playerSmallHeight = 46.0;
  static const double playerBigWidth = 46.0;
  static const double playerBigHeight = 78.0;

  /// Target frame time for manual tick calculation
  static const Duration frameDuration = Duration(milliseconds: 16);

  /// Default level time in seconds
  static const int defaultLevelTime = 300;

  /// Scoring constants
  static const int scoreCoin = 100;
  static const int scorePowerUp = 500;
  static const int scoreEnemyDefeat = 200;
  static const int scoreTimeBonusMultiplier = 10;

  /// Palette (Arcade Retro Style)
  static const Color skyColor = Color(0xFF5C94FC);
  static const Color groundGrassColor = Color(0xFF00A800);
  static const Color groundDirtColor = Color(0xFFB84418);
  static const Color brickColor = Color(0xFFC84C0C);
  static const Color questionBlockColor = Color(0xFFFC9838);
  static const Color usedBlockColor = Color(0xFF7A5230);
  static const Color playerSmallColor = Color(0xFFE52521);
  static const Color playerBigColor = Color(0xFF00A800);
  static const Color enemyColor = Color(0xFF8B0000);
  static const Color coinColor = Color(0xFFFFD700);
  static const Color mushroomColor = Color(0xFFE52521);
  static const Color hudBackgroundColor = Color(0xCC000000);
}
