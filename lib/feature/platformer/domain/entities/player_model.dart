import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';

enum PlayerDirection { left, right }

class PlayerModel {
  double x;
  double y;
  double velocityX;
  double velocityY;

  double width;
  double height;

  bool isGrounded;
  bool isJumping;
  bool isMoving;
  bool isBig;
  bool isInvulnerable;

  PlayerDirection direction;
  int lives;
  int score;

  PlayerModel({
    required this.x,
    required this.y,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
    this.width = GameConfig.playerSmallWidth,
    this.height = GameConfig.playerSmallHeight,
    this.isGrounded = false,
    this.isJumping = false,
    this.isMoving = false,
    this.isBig = false,
    this.isInvulnerable = false,
    this.direction = PlayerDirection.right,
    this.lives = 3,
    this.score = 0,
  });

  /// Bounding rectangle for collision detection
  Rect get rect => Rect.fromLTWH(x, y, width, height);

  double get bottom => y + height;
  double get top => y;
  double get left => x;
  double get right => x + width;

  /// Grow to Big Player state
  void grow() {
    if (isBig) return;
    isBig = true;
    final oldHeight = height;
    height = GameConfig.playerBigHeight;
    width = GameConfig.playerBigWidth;
    // Adjust Y so feet stay on the exact same surface
    y -= (height - oldHeight);
  }

  /// Shrink to Small Player state
  void shrink() {
    if (!isBig) return;
    isBig = false;
    final oldHeight = height;
    height = GameConfig.playerSmallHeight;
    width = GameConfig.playerSmallWidth;
    // Adjust Y so feet stay anchored
    y += (oldHeight - height);
  }

  /// Reset position and state to spawn point
  void resetToSpawn(double spawnX, double spawnY) {
    x = spawnX;
    y = spawnY;
    velocityX = 0;
    velocityY = 0;
    isGrounded = false;
    isJumping = false;
    isMoving = false;
    direction = PlayerDirection.right;
  }
}
