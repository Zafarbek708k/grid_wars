import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';

/// One brand color per game, reused everywhere that game shows up: its
/// Home grid tile, its reset button, and its win/lose dialog buttons — so
/// each game reads as a consistent, distinct "clay" color throughout.
const Map<HomeScreenApps, Color> gameAccentColors = {
  HomeScreenApps.mario2D: AppColors.orange,
  HomeScreenApps.ticTacToe: AppColors.blue,
  HomeScreenApps.math: AppColors.green,
  HomeScreenApps.fifteenPuzzle: AppColors.teal,
  HomeScreenApps.sudoku: AppColors.indigo,
  HomeScreenApps.nard: AppColors.red,
  HomeScreenApps.wordSearch: AppColors.pink,
  HomeScreenApps.game2048: AppColors.amber,
  HomeScreenApps.minesweeper: AppColors.lime,
};

Color gameAccentColor(HomeScreenApps app) => gameAccentColors[app] ?? AppColors.cyan;
