import 'package:flutter/material.dart';

/// A collectible coin placed directly in the level (as opposed to one
/// popped out of a question block).
class CoinModel {
  final String id;
  final double x;
  final double y;
  final double width;
  final double height;
  bool collected;

  CoinModel({
    required this.id,
    required this.x,
    required this.y,
    this.width = 22.0,
    this.height = 22.0,
    this.collected = false,
  });

  Rect get rect => Rect.fromLTWH(x, y, width, height);
}
