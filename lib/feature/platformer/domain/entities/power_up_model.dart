import 'package:flutter/material.dart';

enum PowerUpType { mushroom }

/// A power-up spawned out of a question block, sitting on top of it until
/// the player walks into it.
class PowerUpModel {
  final String id;
  final PowerUpType type;
  double x;
  double y;
  final double width;
  final double height;

  PowerUpModel({
    required this.id,
    required this.x,
    required this.y,
    this.type = PowerUpType.mushroom,
    this.width = 30.0,
    this.height = 30.0,
  });

  Rect get rect => Rect.fromLTWH(x, y, width, height);
}
