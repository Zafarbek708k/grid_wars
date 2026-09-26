part of 'sudoku_bloc.dart';

class SudokuState extends Equatable {
  final SudokuDifficulty difficulty;
  final List<List<int>> givens;
  final List<List<int>> solution;
  final List<List<int>> board;
  final int? selectedRow;
  final int? selectedCol;
  final int mistakes;
  final bool isSolved;

  const SudokuState({
    this.difficulty = SudokuDifficulty.easy,
    this.givens = const [],
    this.solution = const [],
    this.board = const [],
    this.selectedRow,
    this.selectedCol,
    this.mistakes = 0,
    this.isSolved = false,
  });

  bool isGiven(int row, int col) => givens[row][col] != 0;

  bool hasError(int row, int col) {
    final value = board[row][col];
    return value != 0 && value != solution[row][col];
  }

  SudokuState copyWith({
    SudokuDifficulty? difficulty,
    List<List<int>>? givens,
    List<List<int>>? solution,
    List<List<int>>? board,
    int? selectedRow,
    int? selectedCol,
    bool clearSelection = false,
    int? mistakes,
    bool? isSolved,
  }) {
    return SudokuState(
      difficulty: difficulty ?? this.difficulty,
      givens: givens ?? this.givens,
      solution: solution ?? this.solution,
      board: board ?? this.board,
      selectedRow: clearSelection ? null : (selectedRow ?? this.selectedRow),
      selectedCol: clearSelection ? null : (selectedCol ?? this.selectedCol),
      mistakes: mistakes ?? this.mistakes,
      isSolved: isSolved ?? this.isSolved,
    );
  }

  @override
  List<Object?> get props => [difficulty, givens, solution, board, selectedRow, selectedCol, mistakes, isSolved];
}
