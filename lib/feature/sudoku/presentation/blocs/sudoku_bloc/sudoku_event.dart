part of 'sudoku_bloc.dart';

sealed class SudokuEvent {
  const SudokuEvent();
}

class NewGame$SudokuEvent extends SudokuEvent {
  final SudokuDifficulty difficulty;

  const NewGame$SudokuEvent({required this.difficulty});
}

class SelectCell$SudokuEvent extends SudokuEvent {
  final int row;
  final int col;

  const SelectCell$SudokuEvent({required this.row, required this.col});
}

class InputNumber$SudokuEvent extends SudokuEvent {
  final int value;

  const InputNumber$SudokuEvent({required this.value});
}

class Erase$SudokuEvent extends SudokuEvent {
  const Erase$SudokuEvent();
}

class ResetGame$SudokuEvent extends SudokuEvent {
  const ResetGame$SudokuEvent();
}
