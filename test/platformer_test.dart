import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/player_model.dart';
import 'package:grid_wars/feature/platformer/domain/physics/collision_engine.dart';
import 'package:grid_wars/feature/platformer/presentation/controllers/game_controller.dart';

void main() {
  group('Platformer Physics & Collision Tests', () {
    test('AABB overlap collision check works accurately', () {
      final rectA = Rect.fromLTWH(10, 10, 50, 50);
      final rectB = Rect.fromLTWH(30, 30, 50, 50);
      final rectC = Rect.fromLTWH(100, 100, 20, 20);

      expect(CollisionEngine.isColliding(rectA, rectB), isTrue);
      expect(CollisionEngine.isColliding(rectA, rectC), isFalse);
    });

    test('isLandingOnTop accurately detects top landing and rejects bottom/side', () {
      final platform = Rect.fromLTWH(100, 300, 200, 40);

      // Player falling downward onto platform top
      final playerLanding = Rect.fromLTWH(150, 260, 40, 46); // bottom is at 306
      final bool landed = CollisionEngine.isLandingOnTop(
        player: playerLanding,
        platform: platform,
        previousBottom: 298,
        velocityY: 150.0,
      );
      expect(landed, isTrue);

      // Player moving upward through platform (should not land)
      final bool jumpingUp = CollisionEngine.isLandingOnTop(
        player: playerLanding,
        platform: platform,
        previousBottom: 310,
        velocityY: -200.0,
      );
      expect(jumpingUp, isFalse);

      // Player missing horizontally to the left
      final playerMissLeft = Rect.fromLTWH(50, 260, 40, 46);
      final bool missed = CollisionEngine.isLandingOnTop(
        player: playerMissLeft,
        platform: platform,
        previousBottom: 298,
        velocityY: 150.0,
      );
      expect(missed, isFalse);
    });

    test('Hitting block from below detection', () {
      final block = Rect.fromLTWH(100, 200, 40, 40); // top: 200, bottom: 240
      final player = Rect.fromLTWH(100, 235, 40, 46); // top: 235

      final bool hit = CollisionEngine.isHittingFromBelow(
        player: player,
        block: block,
        previousTop: 242,
        velocityY: -300.0,
      );
      expect(hit, isTrue);
    });
  });

  group('PlayerModel Tests', () {
    test('Player grow and shrink maintains ground foot alignment', () {
      final player = PlayerModel(x: 100, y: 300);
      final initialBottom = player.bottom;

      player.grow();
      expect(player.isBig, isTrue);
      expect(player.height, GameConfig.playerBigHeight);
      expect(player.bottom, initialBottom);

      player.shrink();
      expect(player.isBig, isFalse);
      expect(player.height, GameConfig.playerSmallHeight);
      expect(player.bottom, initialBottom);
    });
  });

  group('GameController Movement & Jump Tests', () {
    test('Player cannot jump when not grounded (No double jump)', () {
      final controller = GameController();
      controller.startGame();

      controller.player.isGrounded = false;
      controller.player.velocityY = 100.0;

      controller.jump();

      // velocityY must remain unchanged because player was airborne
      expect(controller.player.velocityY, 100.0);
    });

    test('Player jumps successfully when grounded', () {
      final controller = GameController();
      controller.startGame();

      controller.player.isGrounded = true;
      controller.jump();

      expect(controller.player.velocityY, -GameConfig.jumpForce);
      expect(controller.player.isGrounded, isFalse);
      expect(controller.player.isJumping, isTrue);
    });

    test('Hold-to-move left and right sets correct velocity and direction', () {
      final controller = GameController();

      controller.onRightDown();
      expect(controller.player.velocityX, GameConfig.playerSpeed);
      expect(controller.player.direction, PlayerDirection.right);
      expect(controller.player.isMoving, isTrue);

      controller.onRightUp();
      expect(controller.player.velocityX, 0.0);
      expect(controller.player.isMoving, isFalse);

      controller.onLeftDown();
      expect(controller.player.velocityX, -GameConfig.playerSpeed);
      expect(controller.player.direction, PlayerDirection.left);
      expect(controller.player.isMoving, isTrue);

      controller.onLeftUp();
      expect(controller.player.velocityX, 0.0);
      expect(controller.player.isMoving, isFalse);
    });
  });
}
