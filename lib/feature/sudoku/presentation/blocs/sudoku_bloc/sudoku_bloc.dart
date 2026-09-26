import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';
import 'package:grid_wars/feature/sudoku/domain/entities/sudoku_difficulty.dart';
import 'package:grid_wars/feature/sudoku/domain/services/sudoku_generator.dart';

part 'sudoku_event.dart';
part 'sudoku_state.dart';

class SudokuBloc extends Bloc<SudokuEvent, SudokuState> {
  SudokuBloc() : super(const SudokuState()) {
    on<NewGame$SudokuEvent>(_newGame);
    on<SelectCell$SudokuEvent>(_selectCell);
    on<InputNumber$SudokuEvent>(_inputNumber);
    on<Erase$SudokuEvent>(_erase);
    on<ResetGame$SudokuEvent>(_resetGame);

    add(const NewGame$SudokuEvent(difficulty: SudokuDifficulty.easy));
  }

  FutureOr<void> _newGame(NewGame$SudokuEvent event, Emitter<SudokuState> emit) {
    final puzzle = SudokuGenerator.generatePuzzle(event.difficulty);
    emit(
      SudokuState(
        difficulty: event.difficulty,
        givens: puzzle.givens,
        solution: puzzle.solution,
        board: puzzle.givens.map((row) => List<int>.from(row)).toList(),
      ),
    );
  }

  FutureOr<void> _resetGame(ResetGame$SudokuEvent event, Emitter<SudokuState> emit) {
    emit(
      state.copyWith(
        board: state.givens.map((row) => List<int>.from(row)).toList(),
        clearSelection: true,
        mistakes: 0,
        isSolved: false,
      ),
    );
  }

  FutureOr<void> _selectCell(SelectCell$SudokuEvent event, Emitter<SudokuState> emit) {
    if (state.isGiven(event.row, event.col)) return null;
    emit(state.copyWith(selectedRow: event.row, selectedCol: event.col));
  }

  FutureOr<void> _inputNumber(InputNumber$SudokuEvent event, Emitter<SudokuState> emit) {
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null || state.isGiven(row, col)) return null;

    final List<List<int>> newBoard = state.board.map((r) => List<int>.from(r)).toList();
    newBoard[row][col] = event.value;

    final bool isCorrectNow = event.value == state.solution[row][col];
    final int mistakes = isCorrectNow ? state.mistakes : state.mistakes + 1;

    final bool solved = newBoard.indexed.every(
      (rowEntry) => rowEntry.$2.indexed.every((colEntry) => colEntry.$2 == state.solution[rowEntry.$1][colEntry.$1]),
    );
    if (solved) {
      unawaited(DailyChallengeService.notifyGameCompleted('sudoku'));
      unawaited(GameStatsService.recordCompletion('sudoku', value: mistakes, lowerIsBetter: true));
    }

    emit(state.copyWith(board: newBoard, mistakes: mistakes, isSolved: solved));
  }

  FutureOr<void> _erase(Erase$SudokuEvent event, Emitter<SudokuState> emit) {
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null || state.isGiven(row, col)) return null;

    final List<List<int>> newBoard = state.board.map((r) => List<int>.from(r)).toList();
    newBoard[row][col] = 0;
    emit(state.copyWith(board: newBoard));
  }
}
