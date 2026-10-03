import 'package:grid_wars/core/constants/app_icons.dart';

enum HomeScreenApps {
  mario2D(icon: AppIcons.game, name: "Super Platformer", rating: 5, isActive: true),
  ticTacToe(icon: AppIcons.ticTac, name: "Tic Tac Toe", rating: 5, isActive: true),
  fifteenPuzzle(icon: AppIcons.game, name: "15 Puzzle", rating: 4, isActive: true),
  chess(icon: AppIcons.chessRook, name: "Chess", rating: 5, isActive: false),
  sudoku(icon: AppIcons.sudoku, name: "Sudoku", rating: 3, isActive: true),
  math(icon: AppIcons.plusEqual, name: "Mental", rating: 5, isActive: true),
  nard(icon: AppIcons.dice5, name: "Nard", rating: 3, isActive: true),
  wordSearch(icon: AppIcons.language, name: "Word Search", rating: 4, isActive: true),
  game2048(icon: AppIcons.game, name: "2048", rating: 4, isActive: true),
  minesweeper(icon: AppIcons.game, name: "Minesweeper", rating: 4, isActive: true);

  const HomeScreenApps({required this.icon, required this.name, required this.rating, required this.isActive});

  final String icon;
  final String name;
  final int rating;
  final bool isActive;

  bool get isMario2D => this == HomeScreenApps.mario2D;

  bool get isTicTacToe => this == HomeScreenApps.ticTacToe;

  bool get isFifteenPuzzle => this == HomeScreenApps.fifteenPuzzle;

  bool get isChess => this == HomeScreenApps.chess;

  bool get isSudoku => this == HomeScreenApps.sudoku;

  bool get isMath => this == HomeScreenApps.math;

  bool get isNard => this == HomeScreenApps.nard;

  bool get isWordSearch => this == HomeScreenApps.wordSearch;

  bool get isGame2048 => this == HomeScreenApps.game2048;

  bool get isMinesweeper => this == HomeScreenApps.minesweeper;

  static HomeScreenApps fromString(String value) {
    return HomeScreenApps.values.firstWhere((element) => element.name == value, orElse: () => HomeScreenApps.chess);
  }
}
