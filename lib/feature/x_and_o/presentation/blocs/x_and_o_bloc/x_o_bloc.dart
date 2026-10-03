import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_wars/core/enums/game_item_type_enum.dart';
import 'package:grid_wars/core/enums/game_mode_enum.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';
import 'package:grid_wars/feature/x_and_o/domain/entities/bot_difficulty.dart';
import 'package:grid_wars/feature/x_and_o/domain/services/tic_tac_toe_bot.dart';

export 'package:grid_wars/core/enums/game_mode_enum.dart';
export 'package:grid_wars/feature/x_and_o/domain/entities/bot_difficulty.dart';

part 'x_o_event.dart';
part 'x_o_state.dart';

class XOBloc extends Bloc<XOEvent, XOState> {
  XOBloc({Random? random}) : _random = random ?? Random(), super(const XOState()) {
    on<TabEvent>(_tab);
    on<ResetGameEvent>(_resetGame);
    on<SelectMode$XOEvent>(_selectMode);
    on<SelectDifficulty$XOEvent>(_selectDifficulty);
    on<RequestBotMove$XOEvent>(_requestBotMove);
  }

  final Random _random;

  FutureOr<void> _tab(TabEvent event, Emitter<XOState> emit) async {
    if (state.isGameOver || !state.board[event.index].isEmpty) return;
    if (state.isBotTurn) return; // human can't move on the bot's behalf

    _applyMove(event.index, emit);
  }

  void _applyMove(int index, Emitter<XOState> emit) {
    final newBoard = List<GameItemTypeEnum>.from(state.board);
    newBoard[index] = state.currentPlayer;

    final winResult = _checkWinner(newBoard);
    if (winResult != null) {
      unawaited(DailyChallengeService.notifyGameCompleted('ticTacToe'));
      unawaited(GameStatsService.recordCompletion('ticTacToe'));
      emit(
        state.copyWith(board: newBoard, winner: winResult['winner'], isGameOver: true, winningLine: winResult['line']),
      );
    } else if (!newBoard.contains(GameItemTypeEnum.empty)) {
      emit(state.copyWith(board: newBoard, winner: "Draw", isGameOver: true));
    } else {
      final nextPlayer = state.currentPlayer.isX ? GameItemTypeEnum.o : GameItemTypeEnum.x;
      emit(state.copyWith(board: newBoard, currentPlayer: nextPlayer));

      if (state.mode == GameMode.bot && nextPlayer.isO) {
        add(const RequestBotMove$XOEvent());
      }
    }
  }

  FutureOr<void> _requestBotMove(RequestBotMove$XOEvent event, Emitter<XOState> emit) async {
    await Future.delayed(const Duration(milliseconds: 450));
    if (isClosed) return;
    if (state.isGameOver || !state.isBotTurn) return;

    final move = TicTacToeBot.pickMove(state.board, state.botDifficulty, random: _random);
    if (move != null) _applyMove(move, emit);
  }

  FutureOr<void> _selectMode(SelectMode$XOEvent event, Emitter<XOState> emit) async {
    emit(XOState(mode: event.mode, botDifficulty: state.botDifficulty));
  }

  FutureOr<void> _selectDifficulty(SelectDifficulty$XOEvent event, Emitter<XOState> emit) async {
    emit(XOState(mode: state.mode, botDifficulty: event.difficulty));
  }

  FutureOr<void> _resetGame(ResetGameEvent event, Emitter<XOState> emit) async {
    emit(XOState(mode: state.mode, botDifficulty: state.botDifficulty));
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
