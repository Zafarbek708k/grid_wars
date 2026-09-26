enum SudokuDifficulty {
  easy(cellsToRemove: 36),
  medium(cellsToRemove: 46),
  hard(cellsToRemove: 56);

  final int cellsToRemove;

  const SudokuDifficulty({required this.cellsToRemove});

  String get label => switch (this) {
    SudokuDifficulty.easy => 'EASY',
    SudokuDifficulty.medium => 'MEDIUM',
    SudokuDifficulty.hard => 'HARD',
  };
}
