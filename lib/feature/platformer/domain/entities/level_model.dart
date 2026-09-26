import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/coin_model.dart';
import 'package:grid_wars/feature/platformer/domain/entities/platform_model.dart';

class FinishPoint {
  final double x;
  final double y;
  final double width;
  final double height;

  const FinishPoint({
    required this.x,
    required this.y,
    this.width = 40.0,
    this.height = 160.0,
  });

  Rect get rect => Rect.fromLTWH(x, y, width, height);
}

class LevelModel {
  final String id;
  final String title;
  final double worldWidth;
  final double worldHeight;
  final Offset playerSpawn;
  final FinishPoint finishPoint;
  final List<PlatformModel> platforms;
  final List<CoinModel> coins;

  LevelModel({
    required this.id,
    required this.title,
    required this.worldWidth,
    this.worldHeight = GameConfig.virtualWorldHeight,
    required this.playerSpawn,
    required this.finishPoint,
    required this.platforms,
    this.coins = const [],
  });
}
