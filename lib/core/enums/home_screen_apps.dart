import 'package:grid_wars/core/constants/app_icons.dart';

enum HomeScreenApps {
  ticTacToe(icon: AppIcons.ticTac, name: "Tic Tac Toe", rating: 5, isActive: true),
  fifteenPuzzle(icon: AppIcons.game, name: "15 Puzzle", rating: 4, isActive: false),
  chess(icon: AppIcons.chessRook, name: "Chess", rating: 5, isActive: false),
  memoryMatch(icon: AppIcons.brain, name: "Memory Match", rating: 4, isActive: true),
  sudoku(icon: AppIcons.sudoku, name: "Sudoku", rating: 3, isActive: false),
  math(icon: AppIcons.plusEqual, name: "Mental", rating: 5, isActive: false),
  nard(icon: AppIcons.dice5, name: "Nard", rating: 3, isActive: false),
  wordSearch(icon: AppIcons.language, name: "Word Search", rating: 4, isActive: false);

  const HomeScreenApps({required this.icon, required this.name, required this.rating, required this.isActive});

  final String icon;
  final String name;
  final int rating;
  final bool isActive;

  bool get isTicTacToe => this == HomeScreenApps.ticTacToe;

  bool get isFifteenPuzzle => this == HomeScreenApps.fifteenPuzzle;

  bool get isChess => this == HomeScreenApps.chess;

  bool get isMemoryMatch => this == HomeScreenApps.memoryMatch;

  bool get isSudoku => this == HomeScreenApps.sudoku;

  bool get isMath => this == HomeScreenApps.math;

  bool get isNard => this == HomeScreenApps.nard;

  bool get isWordSearch => this == HomeScreenApps.wordSearch;

  static HomeScreenApps fromString(String value) {
    return HomeScreenApps.values.firstWhere((element) => element.name == value, orElse: () => HomeScreenApps.chess);
  }
}
