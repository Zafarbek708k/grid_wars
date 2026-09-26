part of 'minesweeper_bloc.dart';

sealed class MinesweeperEvent {
  const MinesweeperEvent();
}

class SelectDifficulty$MinesweeperEvent extends MinesweeperEvent {
  final MinesweeperDifficulty difficulty;

  const SelectDifficulty$MinesweeperEvent({required this.difficulty});
}

class RevealCell$MinesweeperEvent extends MinesweeperEvent {
  final int row;
  final int col;

  const RevealCell$MinesweeperEvent({required this.row, required this.col});
}

class ToggleFlag$MinesweeperEvent extends MinesweeperEvent {
  final int row;
  final int col;

  const ToggleFlag$MinesweeperEvent({required this.row, required this.col});
}

class ResetGame$MinesweeperEvent extends MinesweeperEvent {
  const ResetGame$MinesweeperEvent();
}
