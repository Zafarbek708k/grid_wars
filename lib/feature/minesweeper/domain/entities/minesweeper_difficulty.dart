enum MinesweeperDifficulty {
  beginner(rows: 9, cols: 9, mineCount: 10, label: 'BEGINNER'),
  intermediate(rows: 12, cols: 12, mineCount: 20, label: 'INTERMEDIATE');

  final int rows;
  final int cols;
  final int mineCount;
  final String label;

  const MinesweeperDifficulty({
    required this.rows,
    required this.cols,
    required this.mineCount,
    required this.label,
  });
}
