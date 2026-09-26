import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/coin_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/level_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/platform_model.dart';

/// Level 1-1 introductory world with ground sections, floating platforms,
/// a couple of question blocks, and a finish flag.
LevelModel createLevel1() {
  const double groundY = GameConfig.virtualWorldHeight - GameConfig.groundHeight;

  return LevelModel(
    id: '1-1',
    title: 'WORLD 1-1',
    worldWidth: 2600.0,
    worldHeight: GameConfig.virtualWorldHeight,
    playerSpawn: const Offset(80.0, groundY - GameConfig.playerSmallHeight),
    finishPoint: const FinishPoint(
      x: 2450.0,
      y: groundY - 160.0,
      width: 44.0,
      height: 160.0,
    ),
    platforms: [
      // Ground segment 1 (0 to 800)
      PlatformModel(
        id: 'ground_1',
        x: 0,
        y: groundY,
        width: 800,
        height: GameConfig.groundHeight,
        type: PlatformType.ground,
      ),

      // First question block: a simple coin reward, reachable straight up
      PlatformModel(
        id: 'qblock_1',
        x: 200,
        y: groundY - 110,
        width: 40,
        height: 40,
        type: PlatformType.questionBlock,
        bonusType: BonusType.coin,
      ),

      // Low step platform
      PlatformModel(
        id: 'plat_step_1',
        x: 320,
        y: groundY - 70,
        width: 120,
        height: 24,
        type: PlatformType.floating,
      ),

      // High floating platform
      PlatformModel(
        id: 'plat_high_1',
        x: 480,
        y: groundY - 140,
        width: 140,
        height: 24,
        type: PlatformType.floating,
      ),

      // Pit gap between 800 and 920!

      // Ground segment 2 (920 to 1700)
      PlatformModel(
        id: 'ground_2',
        x: 920,
        y: groundY,
        width: 780,
        height: GameConfig.groundHeight,
        type: PlatformType.ground,
      ),

      // Mushroom question block: grows Mario, unlocking the bigger jump
      // needed later in the level
      PlatformModel(
        id: 'qblock_2',
        x: 990,
        y: groundY - 110,
        width: 40,
        height: 40,
        type: PlatformType.questionBlock,
        bonusType: BonusType.mushroom,
      ),

      // A dead, decorative brick with no bonus — proves not every block
      // hides a reward
      PlatformModel(
        id: 'qblock_3',
        x: 1040,
        y: groundY - 110,
        width: 40,
        height: 40,
        type: PlatformType.questionBlock,
      ),

      // Mid-level elevated platforms
      PlatformModel(
        id: 'plat_mid_2',
        x: 1050,
        y: groundY - 90,
        width: 100,
        height: 24,
        type: PlatformType.floating,
      ),
      PlatformModel(
        id: 'plat_mid_3',
        x: 1220,
        y: groundY - 150,
        width: 120,
        height: 24,
        type: PlatformType.floating,
      ),
      PlatformModel(
        id: 'plat_mid_4',
        x: 1400,
        y: groundY - 80,
        width: 100,
        height: 24,
        type: PlatformType.floating,
      ),

      // Pit gap between 1700 and 1820!

      // Ground segment 3 (1820 to 2600 - Goal Area)
      PlatformModel(
        id: 'ground_3',
        x: 1820,
        y: groundY,
        width: 780,
        height: GameConfig.groundHeight,
        type: PlatformType.ground,
      ),

      // Victory staircase
      PlatformModel(
        id: 'stair_1',
        x: 2100,
        y: groundY - 30,
        width: 60,
        height: 30,
        type: PlatformType.brick,
      ),
      PlatformModel(
        id: 'stair_2',
        x: 2160,
        y: groundY - 60,
        width: 60,
        height: 60,
        type: PlatformType.brick,
      ),
      PlatformModel(
        id: 'stair_3',
        x: 2220,
        y: groundY - 90,
        width: 60,
        height: 90,
        type: PlatformType.brick,
      ),
      PlatformModel(
        id: 'stair_4',
        x: 2280,
        y: groundY - 120,
        width: 60,
        height: 120,
        type: PlatformType.brick,
      ),
    ],
    coins: [
      CoinModel(id: 'coin_1', x: 355, y: groundY - 70 - 30),
      CoinModel(id: 'coin_2', x: 535, y: groundY - 140 - 30),
      CoinModel(id: 'coin_3', x: 1085, y: groundY - 90 - 30),
      CoinModel(id: 'coin_4', x: 1255, y: groundY - 150 - 30),
      CoinModel(id: 'coin_5', x: 1435, y: groundY - 80 - 30),
      CoinModel(id: 'coin_6', x: 2115, y: groundY - 60),
      CoinModel(id: 'coin_7', x: 2235, y: groundY - 120),
    ],
  );
}
