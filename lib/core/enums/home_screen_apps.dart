enum HomeScreenApps {
  ticTacToe(icon: "assets/icons/o.svg", name: "Tic Tac Toe", rating: 5, isActive: true),
  fifteenPuzzle(icon: "assets/icons/game.svg", name: "15 Puzzle", rating: 5, isActive: false),
  chess(icon: "assets/icons/castle.svg", name: "Chess", rating: 5, isActive: false),
  memoryMatch(icon: "assets/icons/castle.svg", name: "Memory Match", rating: 5, isActive: false),
  sudoku(icon: "assets/icons/castle.svg", name: "Sudoku", rating: 5, isActive: false),
  wordSearch(icon: "assets/icons/castle.svg", name: "Word Search", rating: 5, isActive: false);

  const HomeScreenApps({required this.icon, required this.name, required this.rating, required this.isActive});

  final String icon;
  final String name;
  final int rating;
  final bool isActive;

  bool get isTicTacToe => this == HomeScreenApps.ticTacToe;

  bool get isFifteenPuzzle => this == HomeScreenApps.fifteenPuzzle;

  bool get isChess => this == HomeScreenApps.chess;
}
