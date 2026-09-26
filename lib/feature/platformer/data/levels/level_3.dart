import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/coin_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/level_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/platform_model.dart';

/// Level 1-3: the finale — narrow floating platforms, back-to-back pits,
/// and several question blocks including two mushrooms for the longest
/// jumps of the run.
LevelModel createLevel3() {
  const double groundY = GameConfig.virtualWorldHeight - GameConfig.groundHeight;

  return LevelModel(
    id: '1-3',
    title: 'WORLD 1-3',
    worldWidth: 3100.0,
    worldHeight: GameConfig.virtualWorldHeight,
    playerSpawn: const Offset(80.0, groundY - GameConfig.playerSmallHeight),
    finishPoint: const FinishPoint(
      x: 2960.0,
      y: groundY - 160.0,
      width: 44.0,
      height: 160.0,
    ),
    platforms: [
      // Ground segment 1 (0 to 500)
      PlatformModel(id: 'ground_1', x: 0, y: groundY, width: 500, height: GameConfig.groundHeight, type: PlatformType.ground),

      // Early mushroom — grow right away, this level rewards being big
      PlatformModel(id: 'qblock_mushroom_1', x: 220, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.mushroom),

      PlatformModel(id: 'pipe_1', x: 400, y: groundY - 60, width: 56, height: 60, type: PlatformType.pipe),

      // Pit gap 500 - 600
      PlatformModel(id: 'plat_gap_1', x: 540, y: groundY - 30, width: 60, height: 24, type: PlatformType.floating),

      // Ground segment 2 (600 to 1000)
      PlatformModel(id: 'ground_2', x: 600, y: groundY, width: 400, height: GameConfig.groundHeight, type: PlatformType.ground),

      PlatformModel(id: 'qblock_1', x: 680, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.coin),
      PlatformModel(id: 'qblock_2', x: 730, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock),
      PlatformModel(id: 'qblock_3', x: 780, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.coin),

      // Narrow floating platform chain over a long pit (1000 - 1500)
      PlatformModel(id: 'plat_chain_1', x: 1020, y: groundY - 60, width: 70, height: 24, type: PlatformType.floating),
      PlatformModel(id: 'plat_chain_2', x: 1150, y: groundY - 110, width: 70, height: 24, type: PlatformType.floating),
      PlatformModel(id: 'plat_chain_3', x: 1280, y: groundY - 150, width: 70, height: 24, type: PlatformType.floating),
      PlatformModel(id: 'plat_chain_4', x: 1410, y: groundY - 110, width: 70, height: 24, type: PlatformType.floating),

      // Ground segment 3 (1500 to 1850)
      PlatformModel(id: 'ground_3', x: 1500, y: groundY, width: 350, height: GameConfig.groundHeight, type: PlatformType.ground),

      PlatformModel(id: 'pipe_2', x: 1600, y: groundY - 90, width: 60, height: 90, type: PlatformType.pipe),
      PlatformModel(id: 'pipe_3', x: 1700, y: groundY - 60, width: 56, height: 60, type: PlatformType.pipe),

      // Second mushroom right before the finale's widest gap
      PlatformModel(id: 'qblock_mushroom_2', x: 1790, y: groundY - 170, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.mushroom),

      // Widest pit of the game (1850 - 2100)
      PlatformModel(id: 'plat_gap_2', x: 1920, y: groundY - 80, width: 60, height: 24, type: PlatformType.floating),
      PlatformModel(id: 'plat_gap_3', x: 2020, y: groundY - 40, width: 60, height: 24, type: PlatformType.floating),

      // Ground segment 4 (2100 to 2450)
      PlatformModel(id: 'ground_4', x: 2100, y: groundY, width: 350, height: GameConfig.groundHeight, type: PlatformType.ground),

      PlatformModel(id: 'qblock_4', x: 2180, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.coin),
      PlatformModel(id: 'qblock_5', x: 2230, y: groundY - 110, width: 40, height: 40, type: PlatformType.questionBlock, bonusType: BonusType.coin),

      // Final narrow run to the flag (2450 to 3100 - Goal Area)
      PlatformModel(id: 'ground_5', x: 2450, y: groundY, width: 650, height: GameConfig.groundHeight, type: PlatformType.ground),

      // Victory staircase
      PlatformModel(id: 'stair_1', x: 2760, y: groundY - 30, width: 60, height: 30, type: PlatformType.brick),
      PlatformModel(id: 'stair_2', x: 2820, y: groundY - 60, width: 60, height: 60, type: PlatformType.brick),
      PlatformModel(id: 'stair_3', x: 2880, y: groundY - 90, width: 60, height: 90, type: PlatformType.brick),
      PlatformModel(id: 'stair_4', x: 2940, y: groundY - 120, width: 60, height: 120, type: PlatformType.brick),
    ],
    coins: [
      CoinModel(id: 'coin_1', x: 1035, y: groundY - 60 - 30),
      CoinModel(id: 'coin_2', x: 1165, y: groundY - 110 - 30),
      CoinModel(id: 'coin_3', x: 1295, y: groundY - 150 - 30),
      CoinModel(id: 'coin_4', x: 1425, y: groundY - 110 - 30),
      CoinModel(id: 'coin_5', x: 1935, y: groundY - 80 - 30),
      CoinModel(id: 'coin_6', x: 2035, y: groundY - 40 - 30),
      CoinModel(id: 'coin_7', x: 2195, y: groundY - 160),
      CoinModel(id: 'coin_8', x: 2245, y: groundY - 160),
    ],
  );
}
