import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';

part 'nard_event.dart';
part 'nard_state.dart';

/// A 2-player dice-count companion for Nard (backgammon) — no board or
/// pieces, just whose turn it is, the last roll, and each player's running
/// total.
class NardBloc extends Bloc<NardEvent, NardState> {
  NardBloc({Random? random}) : _random = random ?? Random(), super(const NardState()) {
    on<RollDice$NardEvent>(_rollDice);
    on<ResetGame$NardEvent>(_resetGame);
  }

  final Random _random;

  FutureOr<void> _rollDice(RollDice$NardEvent event, Emitter<NardState> emit) {
    final int dice1 = _random.nextInt(6) + 1;
    final int dice2 = _random.nextInt(6) + 1;
    final int total = dice1 + dice2;
    unawaited(GameStatsService.recordCompletion('nard'));

    emit(
      state.copyWith(
        dice1: dice1,
        dice2: dice2,
        hasRolled: true,
        player1Score: state.currentPlayer == 1 ? state.player1Score + total : state.player1Score,
        player2Score: state.currentPlayer == 2 ? state.player2Score + total : state.player2Score,
        currentPlayer: state.currentPlayer == 1 ? 2 : 1,
      ),
    );
  }

  FutureOr<void> _resetGame(ResetGame$NardEvent event, Emitter<NardState> emit) {
    emit(const NardState());
  }
}
