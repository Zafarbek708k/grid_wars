import 'package:flutter/material.dart';

enum PlatformType { ground, floating, brick, pipe, questionBlock }

/// Reward hidden inside a [PlatformType.questionBlock].
enum BonusType { coin, mushroom }

class PlatformModel {
  final String id;
  final double x;
  final double y;
  final double width;
  final double height;
  final PlatformType type;

  /// Only meaningful for [PlatformType.questionBlock]. Null means the block
  /// is decorative and just bumps Mario's head without a reward.
  final BonusType? bonusType;

  /// Whether a question block's bonus has already been claimed.
  bool isUsed;

  PlatformModel({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.type = PlatformType.floating,
    this.bonusType,
    this.isUsed = false,
  });

  Rect get rect => Rect.fromLTWH(x, y, width, height);

  double get top => y;
  double get bottom => y + height;
  double get left => x;
  double get right => x + width;
}
