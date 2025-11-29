import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_icons.dart';

enum GameItemTypeEnum {
  x(color: AppColors.blue, name: "X", icon: AppIcons.x),
  o(color: AppColors.green, name: "O", icon: AppIcons.o),
  empty(color: AppColors.gold, name: "", icon: AppIcons.empty);

  final String icon;
  final String name;
  final Color color;

  const GameItemTypeEnum({required this.icon, required this.color, required this.name});

  bool get isX => this == GameItemTypeEnum.x;

  bool get isO => this == GameItemTypeEnum.o;

  bool get isEmpty => this == GameItemTypeEnum.empty;
}
