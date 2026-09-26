import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/coin_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/level_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/platform_model.dart';

/// Level 1-2: pipes to hop over, a tighter platforming staircase, and a
/// mushroom block placed right before the widest gap of the level.
LevelModel createLevel2() {
  const double groundY = GameConfig.virtualWorldHeight - GameConfig.groundHeight;

  return LevelModel(
    id: '1-2',
    title: 'WORLD 1-2',
    worldWidth: 2900.0,
    worldHeight: GameConfig.virtualWorldHeight,
    playerSpawn: const Offset(80.0, groundY - GameConfig.playerSmallHeight),
    finishPoint: const FinishPoint(
      x: 2760.0,
      y: groundY - 160.0,
      width: 44.0,
      height: 160.0,
    ),
    platforms: [
      // Ground segment 1 (0 to 620)
      PlatformModel(id: 'ground_1', x: 0, y: groundY, width: 620, height: GameConfig.groundHeight, type: PlatformType.ground),

      // Pipe obstacle to jump over
      PlatformModel(id: 'pipe_1', x: 460, y: groundY - 50, width: 56, height: 50, type: PlatformType.pipe),

      // Pit gap 620 - 720

      // Ground segment 2 (720 to 1480)
      PlatformModel(id: 'ground_2', x: 720, y: groundY, width: 760, height: GameConfig.groundHeight, type: PlatformType.ground),

      // Row of question blocks: coin, empty, coin
      PlatformModel(id: 'qblock_1', x: 800, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.coin),
      PlatformModel(id: 'qblock_2', x: 850, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock),
      PlatformModel(id: 'qblock_3', x: 900, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.coin),

      // Staircase up
      PlatformModel(id: 'stair_up_1', x: 1000, y: groundY - 40, width: 60, height: 40, type: PlatformType.brick),
      PlatformModel(id: 'stair_up_2', x: 1060, y: groundY - 80, width: 60, height: 80, type: PlatformType.brick),
      PlatformModel(id: 'stair_up_3', x: 1120, y: groundY - 120, width: 60, height: 120, type: PlatformType.brick),

      // Tall pipe obstacle
      PlatformModel(id: 'pipe_2', x: 1260, y: groundY - 90, width: 60, height: 90, type: PlatformType.pipe),

      // Floating stepping platforms toward the wide gap
      PlatformModel(id: 'plat_step_1', x: 1380, y: groundY - 60, width: 90, height: 24, type: PlatformType.floating),
      PlatformModel(id: 'plat_step_2', x: 1520, y: groundY - 100, width: 90, height: 24, type: PlatformType.floating),

      // Mushroom block right before the widest gap of the level
      PlatformModel(id: 'qblock_mushroom', x: 1560, y: groundY - 170, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.mushroom),

      // Ground segment 3 (1650 to 2000)
      PlatformModel(id: 'ground_3', x: 1650, y: groundY, width: 350, height: GameConfig.groundHeight, type: PlatformType.ground),

      // Wide pit gap 2000 - 2220 — much easier once Mario is big

      // Ground segment 4 (2220 to 2900 - Goal Area)
      PlatformModel(id: 'ground_4', x: 2220, y: groundY, width: 680, height: GameConfig.groundHeight, type: PlatformType.ground),

      PlatformModel(id: 'qblock_final', x: 2320, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.coin),

      // Victory staircase
      PlatformModel(id: 'stair_1', x: 2520, y: groundY - 30, width: 60, height: 30, type: PlatformType.brick),
      PlatformModel(id: 'stair_2', x: 2580, y: groundY - 60, width: 60, height: 60, type: PlatformType.brick),
      PlatformModel(id: 'stair_3', x: 2640, y: groundY - 90, width: 60, height: 90, type: PlatformType.brick),
      PlatformModel(id: 'stair_4', x: 2700, y: groundY - 120, width: 60, height: 120, type: PlatformType.brick),
    ],
    coins: [
      CoinModel(id: 'coin_1', x: 1015, y: groundY - 40 - 30),
      CoinModel(id: 'coin_2', x: 1075, y: groundY - 80 - 30),
      CoinModel(id: 'coin_3', x: 1135, y: groundY - 120 - 30),
      CoinModel(id: 'coin_4', x: 1405, y: groundY - 60 - 30),
      CoinModel(id: 'coin_5', x: 1545, y: groundY - 100 - 30),
      CoinModel(id: 'coin_6', x: 2340, y: groundY - 160),
      CoinModel(id: 'coin_7', x: 2600, y: groundY - 90),
    ],
  );
}
