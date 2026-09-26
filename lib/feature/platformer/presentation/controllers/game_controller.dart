import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/data/levels/levels.dart';
import 'package:grid_wars/feature/platformer/domain/entities/level_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/platform_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/player_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/power_up_model.dart';
import 'package:grid_wars/feature/platformer/domain/physics/collision_engine.dart';

enum GameStatus { ready, playing, paused, levelComplete, gameOver }

class GameController extends ChangeNotifier {
  late LevelModel level;
  late PlayerModel player;

  int _currentLevelIndex = 0;
  bool get isLastLevel => _currentLevelIndex >= platformerLevelBuilders.length - 1;

  final List<PowerUpModel> activePowerUps = [];

  GameStatus _status = GameStatus.ready;
  GameStatus get status => _status;

  int _timeRemaining = GameConfig.defaultLevelTime;
  int get timeRemaining => _timeRemaining;

  int _coins = 0;
  int get coins => _coins;

  double _cameraX = 0.0;
  double get cameraX => _cameraX;

  double _viewportWidth = 800.0;

  // Single ticker for controlled 60 FPS update
  Ticker? _ticker;
  Duration? _lastElapsed;
  double _secondAccumulator = 0.0;

  // Input states
  bool _isMovingLeft = false;
  bool _isMovingRight = false;

  GameController({TickerProvider? vsync}) {
    level = platformerLevelBuilders[_currentLevelIndex]();
    player = PlayerModel(
      x: level.playerSpawn.dx,
      y: level.playerSpawn.dy,
    );

    if (vsync != null) {
      attachTicker(vsync);
    }
  }

  void attachTicker(TickerProvider vsync) {
    _ticker?.dispose();
    _ticker = vsync.createTicker(_onTick);
  }

  void updateViewportWidth(double width) {
    if (width > 0 && _viewportWidth != width) {
      _viewportWidth = width;
      _updateCamera(0.0);
    }
  }

  void startGame() {
    _status = GameStatus.playing;
    _lastElapsed = null;
    _ticker?.start();
    notifyListeners();
  }

  void pauseGame() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
      _ticker?.stop();
      _lastElapsed = null;
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_status == GameStatus.paused) {
      _status = GameStatus.playing;
      _lastElapsed = null;
      _ticker?.start();
      notifyListeners();
    }
  }

  void _loadLevel(int index) {
    _currentLevelIndex = index;
    level = platformerLevelBuilders[index]();
    activePowerUps.clear();
    player.resetToSpawn(level.playerSpawn.dx, level.playerSpawn.dy);
    player.velocityX = 0;
    _timeRemaining = GameConfig.defaultLevelTime;
    _coins = 0;
    _cameraX = 0.0;
    _isMovingLeft = false;
    _isMovingRight = false;
    _secondAccumulator = 0.0;
    _status = GameStatus.playing;
    _lastElapsed = null;
    if (_ticker?.isActive == false) {
      _ticker?.start();
    }
    notifyListeners();
  }

  void restartLevel() => _loadLevel(_currentLevelIndex);

  void nextLevel() {
    if (isLastLevel) {
      restartLevel();
    } else {
      _loadLevel(_currentLevelIndex + 1);
    }
  }

  // --- Input Handlers (Hold-to-move & Keyboard) ---

  void onLeftDown() {
    _isMovingLeft = true;
    player.direction = PlayerDirection.left;
    _updateHorizontalVelocity();
  }

  void onLeftUp() {
    _isMovingLeft = false;
    _updateHorizontalVelocity();
  }

  void onRightDown() {
    _isMovingRight = true;
    player.direction = PlayerDirection.right;
    _updateHorizontalVelocity();
  }

  void onRightUp() {
    _isMovingRight = false;
    _updateHorizontalVelocity();
  }

  void jump() {
    if (_status != GameStatus.playing) return;

    // Strict No-Double-Jump rule: must be grounded
    if (!player.isGrounded) return;

    final double jumpForce = player.isBig ? GameConfig.jumpForceBig : GameConfig.jumpForce;
    player.velocityY = -jumpForce;
    player.isGrounded = false;
    player.isJumping = true;
    notifyListeners();
  }

  void _updateHorizontalVelocity() {
    final double speed = player.isBig ? GameConfig.playerSpeedBig : GameConfig.playerSpeed;
    if (_isMovingLeft && !_isMovingRight) {
      player.velocityX = -speed;
      player.isMoving = true;
      player.direction = PlayerDirection.left;
    } else if (_isMovingRight && !_isMovingLeft) {
      player.velocityX = speed;
      player.isMoving = true;
      player.direction = PlayerDirection.right;
    } else {
      player.velocityX = 0;
      player.isMoving = false;
    }
  }

  // --- Main Controlled Game Loop (Physics & State Update) ---

  void _onTick(Duration elapsed) {
    if (_status != GameStatus.playing) return;

    if (_lastElapsed == null) {
      _lastElapsed = elapsed;
      return;
    }

    final int deltaMicros = (elapsed - _lastElapsed!).inMicroseconds;
    _lastElapsed = elapsed;

    // Clamp delta time to avoid large jumps if frame drops occur (max 33ms)
    final double dt = math.min(deltaMicros / 1000000.0, 0.033);
    if (dt <= 0) return;

    _updateTimer(dt);
    _updatePhysics(dt);
    _checkCollectibles();
    _checkFinishCollision();
    _updateCamera(dt);

    notifyListeners();
  }

  void _updateTimer(double dt) {
    _secondAccumulator += dt;
    if (_secondAccumulator >= 1.0) {
      _secondAccumulator -= 1.0;
      _timeRemaining--;
      if (_timeRemaining <= 0) {
        _onTimeExpired();
      }
    }
  }

  void _updatePhysics(double dt) {
    // 1. Horizontal integration
    player.x += player.velocityX * dt;

    // World boundary clamping
    if (player.x < 0) {
      player.x = 0;
    } else if (player.x + player.width > level.worldWidth) {
      player.x = level.worldWidth - player.width;
    }

    // 2. Vertical integration with gravity
    player.velocityY += GameConfig.gravity * dt;
    if (player.velocityY > GameConfig.maxFallSpeed) {
      player.velocityY = GameConfig.maxFallSpeed;
    }

    final double previousTop = player.top;
    final double previousBottom = player.bottom;
    player.y += player.velocityY * dt;

    // 3. Landing resolution: standing on top of a platform
    bool landedOnAnyPlatform = false;

    for (final platform in level.platforms) {
      if (CollisionEngine.isLandingOnTop(
        player: player.rect,
        platform: platform.rect,
        previousBottom: previousBottom,
        velocityY: player.velocityY,
      )) {
        player.y = platform.top - player.height;
        player.velocityY = 0.0;
        player.isGrounded = true;
        player.isJumping = false;
        landedOnAnyPlatform = true;
        break;
      }
    }

    if (!landedOnAnyPlatform) {
      player.isGrounded = false;
      if (player.velocityY > 10.0) {
        player.isJumping = true;
      }
    }

    // 4. Ceiling resolution: jumping into the underside of a platform stops
    //    the ascent (Mario's head bumps the block) instead of tunnelling
    //    through it, and pops a question block's bonus if it has one.
    for (final platform in level.platforms) {
      if (CollisionEngine.isHittingFromBelow(
        player: player.rect,
        block: platform.rect,
        previousTop: previousTop,
        velocityY: player.velocityY,
      )) {
        player.y = platform.bottom;
        player.velocityY = 0.0;
        player.isJumping = false;
        _hitBlockFromBelow(platform);
        break;
      }
    }

    // 5. Pit hazard check (falling off the bottom of the world)
    if (player.y > level.worldHeight + 80) {
      _handlePlayerDeath();
    }
  }

  void _hitBlockFromBelow(PlatformModel platform) {
    if (platform.type != PlatformType.questionBlock || platform.isUsed) return;

    platform.isUsed = true;
    switch (platform.bonusType) {
      case BonusType.coin:
        _coins++;
        player.score += GameConfig.scoreCoin;
        break;
      case BonusType.mushroom:
        activePowerUps.add(
          PowerUpModel(
            id: '${platform.id}_mushroom',
            x: platform.x + (platform.width - 30.0) / 2,
            y: platform.top - 30.0,
          ),
        );
        break;
      case null:
        break;
    }
  }

  void _checkCollectibles() {
    for (final coin in level.coins) {
      if (!coin.collected && CollisionEngine.isColliding(player.rect, coin.rect)) {
        coin.collected = true;
        _coins++;
        player.score += GameConfig.scoreCoin;
      }
    }

    if (activePowerUps.isEmpty) return;
    activePowerUps.removeWhere((powerUp) {
      if (CollisionEngine.isColliding(player.rect, powerUp.rect)) {
        player.grow();
        player.score += GameConfig.scorePowerUp;
        return true;
      }
      return false;
    });
  }

  void _checkFinishCollision() {
    if (CollisionEngine.isColliding(player.rect, level.finishPoint.rect)) {
      _status = GameStatus.levelComplete;
      _ticker?.stop();
      // Add level clear score bonus
      player.score += 1000 + (_timeRemaining * GameConfig.scoreTimeBonusMultiplier);
      unawaited(DailyChallengeService.notifyGameCompleted('mario2D'));
    }
  }

  void _updateCamera(double dt) {
    // Smooth camera following player at 35% of viewport width
    final double targetX = player.x - (_viewportWidth * 0.35);
    final double maxCameraX = math.max(0.0, level.worldWidth - _viewportWidth);

    _cameraX = targetX.clamp(0.0, maxCameraX);
  }

  void _handlePlayerDeath() {
    player.lives--;
    if (player.lives <= 0) {
      _status = GameStatus.gameOver;
      _ticker?.stop();
    } else {
      // Respawn player
      player.shrink();
      player.resetToSpawn(level.playerSpawn.dx, level.playerSpawn.dy);
      _cameraX = 0.0;
    }
  }

  void _onTimeExpired() {
    _handlePlayerDeath();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}
