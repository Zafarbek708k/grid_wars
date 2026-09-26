import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_2048/domain/entities/swipe_direction.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';
import 'package:grid_wars/feature/game_2048/domain/services/game_2048_engine.dart';

export 'package:grid_wars/feature/game_2048/domain/entities/swipe_direction.dart';

part 'game2048_event.dart';
part 'game2048_state.dart';

const String _bestScoreKey = 'game_2048_best_score';

class Game2048Bloc extends Bloc<Game2048Event, Game2048State> {
  Game2048Bloc({Random? random}) : _random = random ?? Random(), super(const Game2048State()) {
    on<NewGame$Game2048Event>(_newGame);
    on<Move$Game2048Event>(_move);

    add(const NewGame$Game2048Event());
  }

  final Random _random;

  FutureOr<void> _newGame(NewGame$Game2048Event event, Emitter<Game2048State> emit) {
    List<List<int>> board = Game2048Engine.emptyBoard();
    board = Game2048Engine.withRandomTile(board, _random);
    board = Game2048Engine.withRandomTile(board, _random);

    emit(
      Game2048State(board: board, score: 0, best: StorageRepository.getInt(_bestScoreKey, defValue: 0), isGameOver: false, hasWon: false),
    );
  }

  FutureOr<void> _move(Move$Game2048Event event, Emitter<Game2048State> emit) {
    if (state.isGameOver) return null;

    final moveResult = Game2048Engine.applyMove(state.board, event.direction);
    if (!moveResult.changed) return null;

    final boardWithNewTile = Game2048Engine.withRandomTile(moveResult.board, _random);
    final int newScore = state.score + moveResult.scoreGained;
    final int newBest = max(state.best, newScore);
    final bool hasWon = state.hasWon || Game2048Engine.hasReached2048(boardWithNewTile);
    if (!state.hasWon && hasWon) unawaited(DailyChallengeService.notifyGameCompleted('game2048'));
    final bool isGameOver = !Game2048Engine.hasMovesLeft(boardWithNewTile);
    if (isGameOver) unawaited(GameStatsService.recordCompletion('game2048', value: newScore));

    if (newBest != state.best) {
      unawaited(StorageRepository.putInt(_bestScoreKey, newBest));
    }

    emit(state.copyWith(board: boardWithNewTile, score: newScore, best: newBest, hasWon: hasWon, isGameOver: isGameOver));
  }
}
