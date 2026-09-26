import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/minesweeper/domain/entities/mine_cell.dart';
import 'package:grid_wars/feature/minesweeper/domain/entities/minesweeper_difficulty.dart';
import 'package:grid_wars/feature/minesweeper/domain/services/minesweeper_engine.dart';

export 'package:grid_wars/feature/minesweeper/domain/entities/mine_cell.dart';
export 'package:grid_wars/feature/minesweeper/domain/entities/minesweeper_difficulty.dart';

part 'minesweeper_event.dart';
part 'minesweeper_state.dart';

class MinesweeperBloc extends Bloc<MinesweeperEvent, MinesweeperState> {
  MinesweeperBloc({Random? random}) : _random = random ?? Random(), super(const MinesweeperState()) {
    on<SelectDifficulty$MinesweeperEvent>(_selectDifficulty);
    on<RevealCell$MinesweeperEvent>(_revealCell);
    on<ToggleFlag$MinesweeperEvent>(_toggleFlag);
    on<ResetGame$MinesweeperEvent>(_resetGame);

    add(const SelectDifficulty$MinesweeperEvent(difficulty: MinesweeperDifficulty.beginner));
  }

  final Random _random;

  FutureOr<void> _selectDifficulty(SelectDifficulty$MinesweeperEvent event, Emitter<MinesweeperState> emit) {
    emit(
      MinesweeperState(
        difficulty: event.difficulty,
        board: MinesweeperEngine.emptyBoard(event.difficulty.rows, event.difficulty.cols),
      ),
    );
  }

  FutureOr<void> _resetGame(ResetGame$MinesweeperEvent event, Emitter<MinesweeperState> emit) {
    emit(
      MinesweeperState(
        difficulty: state.difficulty,
        board: MinesweeperEngine.emptyBoard(state.difficulty.rows, state.difficulty.cols),
      ),
    );
  }

  FutureOr<void> _revealCell(RevealCell$MinesweeperEvent event, Emitter<MinesweeperState> emit) {
    if (state.isGameOver || state.isWin) return null;

    final cell = state.board[event.row][event.col];
    if (cell.isRevealed || cell.isFlagged) return null;

    final board = state.board;
    bool firstClickDone = state.firstClickDone;

    if (!firstClickDone) {
      MinesweeperEngine.placeMines(board, state.difficulty.mineCount, event.row, event.col, _random);
      firstClickDone = true;
    }

    if (cell.isMine) {
      MinesweeperEngine.revealAllMines(board);
      emit(state.copyWith(board: board, firstClickDone: firstClickDone, isGameOver: true));
      return null;
    }

    MinesweeperEngine.revealCell(board, event.row, event.col);
    final bool won = MinesweeperEngine.isWin(board);
    if (won) unawaited(DailyChallengeService.notifyGameCompleted('minesweeper'));

    emit(state.copyWith(board: board, firstClickDone: firstClickDone, isWin: won));
  }

  FutureOr<void> _toggleFlag(ToggleFlag$MinesweeperEvent event, Emitter<MinesweeperState> emit) {
    if (state.isGameOver || state.isWin) return null;

    final cell = state.board[event.row][event.col];
    if (cell.isRevealed) return null;

    cell.isFlagged = !cell.isFlagged;
    emit(state.copyWith(board: state.board));
  }
}
