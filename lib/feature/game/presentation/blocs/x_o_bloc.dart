import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grid_wars/core/enums/game_item_type_enum.dart';

part 'x_o_event.dart';

part 'x_o_state.dart';

class XOBloc extends Bloc<XOEvent, XOState> {
  XOBloc() : super(const XOState()) {
    on<TabEvent>(_tab);
    on<ResetGameEvent>(_resetGame);
  }

  FutureOr<void> _tab(TabEvent event, Emitter<XOState> emit) async {
    if (state.isGameOver || !state.board[event.index].isEmpty) {
      return;
    }
    final newBoard = List<GameItemTypeEnum>.from(state.board);
    newBoard[event.index] = state.currentPlayer;

    final winResult = _checkWinner(newBoard);

    if (winResult != null) {
      emit(
        state.copyWith(board: newBoard, winner: winResult['winner'], isGameOver: true, winningLine: winResult['line']),
      );
    } else if (!newBoard.contains(GameItemTypeEnum.empty)) {
      emit(state.copyWith(board: newBoard, winner: "Draw", isGameOver: true));
    } else {
      emit(
        state.copyWith(
          board: newBoard,
          currentPlayer: state.currentPlayer.isX ? GameItemTypeEnum.o : GameItemTypeEnum.x,
        ),
      );
    }
  }

  FutureOr<void> _resetGame(ResetGameEvent event, Emitter<XOState> emit) async {
    emit(
      state.copyWith(
        board: List<GameItemTypeEnum>.filled(9, GameItemTypeEnum.empty),
        currentPlayer: GameItemTypeEnum.x,
        isGameOver: false,
        winningLine: [],
      ),
    );
  }

  Map<String, dynamic>? _checkWinner(List<GameItemTypeEnum> board) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      final a = board[pattern[0]];
      final b = board[pattern[1]];
      final c = board[pattern[2]];

      if (!a.isEmpty && a == b && b == c) {
        return {'winner': a.name, 'line': pattern};
      }
    }

    return null;
  }
}
