import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';

enum GameItemTypeEnum {
  x(color: AppColors.white, icon: ""),
  o(color: AppColors.white, icon: ""),
  empty(color: AppColors.white, icon: "");

  final String icon;
  final Color color;

  const GameItemTypeEnum({required this.icon, required this.color});

  bool get isX => this == GameItemTypeEnum.x;

  bool get isO => this == GameItemTypeEnum.o;

  bool get isEmpty => this == GameItemTypeEnum.empty;
}
