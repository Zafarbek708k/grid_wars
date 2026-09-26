/// A generated Sudoku puzzle: the given clues (0 = empty, editable) and its
/// unique solution.
class SudokuPuzzle {
  final List<List<int>> givens;
  final List<List<int>> solution;

  const SudokuPuzzle({required this.givens, required this.solution});
}
