import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';
import 'package:grid_wars/feature/hangman/domain/services/hangman_engine.dart';
import 'package:grid_wars/feature/hangman/domain/services/hangman_word_bank.dart';

part 'hangman_event.dart';
part 'hangman_state.dart';

class HangmanBloc extends Bloc<HangmanEvent, HangmanState> {
  HangmanBloc({Random? random}) : _random = random ?? Random(), super(const HangmanState()) {
    on<NewGame$HangmanEvent>(_newGame);
    on<GuessLetter$HangmanEvent>(_guessLetter);
    add(const NewGame$HangmanEvent());
  }

  final Random _random;

  void _newGame(NewGame$HangmanEvent event, Emitter<HangmanState> emit) {
    final entry = hangmanWordBank[_random.nextInt(hangmanWordBank.length)];
    emit(HangmanState(word: entry.word, hint: entry.hint));
  }

  void _guessLetter(GuessLetter$HangmanEvent event, Emitter<HangmanState> emit) {
    if (state.isGameOver || state.guessedLetters.contains(event.letter)) return;

    final HangmanState next = state.copyWith(guessedLetters: {...state.guessedLetters, event.letter});
    emit(next);

    if (next.isWin) {
      unawaited(DailyChallengeService.notifyGameCompleted('hangman'));
      unawaited(GameStatsService.recordCompletion('hangman'));
    }
  }
}
