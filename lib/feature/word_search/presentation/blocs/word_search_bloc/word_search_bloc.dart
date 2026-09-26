import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/word_search/domain/services/word_search_generator.dart';

part 'word_search_event.dart';
part 'word_search_state.dart';

class WordSearchBloc extends Bloc<WordSearchEvent, WordSearchState> {
  WordSearchBloc({Random? random}) : _random = random ?? Random(), super(const WordSearchState()) {
    on<NewGame$WordSearchEvent>(_newGame);
    on<StartSelection$WordSearchEvent>(_startSelection);
    on<UpdateSelection$WordSearchEvent>(_updateSelection);
    on<EndSelection$WordSearchEvent>(_endSelection);

    add(const NewGame$WordSearchEvent());
  }

  final Random _random;

  FutureOr<void> _newGame(NewGame$WordSearchEvent event, Emitter<WordSearchState> emit) {
    final puzzle = WordSearchGenerator.generate(random: _random);
    emit(WordSearchState(grid: puzzle.grid, words: puzzle.words));
  }

  FutureOr<void> _startSelection(StartSelection$WordSearchEvent event, Emitter<WordSearchState> emit) {
    if (state.isSolved) return null;
    emit(state.copyWith(selection: [(event.row, event.col)]));
  }

  FutureOr<void> _updateSelection(UpdateSelection$WordSearchEvent event, Emitter<WordSearchState> emit) {
    if (state.selection.isEmpty) return null;

    final (anchorRow, anchorCol) = state.selection.first;
    final int dRow = event.row - anchorRow;
    final int dCol = event.col - anchorCol;

    if (dRow == 0 && dCol == 0) {
      emit(state.copyWith(selection: [(anchorRow, anchorCol)]));
      return null;
    }

    final bool isStraightLine = dRow == 0 || dCol == 0 || dRow.abs() == dCol.abs();
    if (!isStraightLine) return null;

    final int steps = dRow.abs() > dCol.abs() ? dRow.abs() : dCol.abs();
    final int stepRow = dRow == 0 ? 0 : dRow ~/ dRow.abs();
    final int stepCol = dCol == 0 ? 0 : dCol ~/ dCol.abs();

    final List<(int, int)> newSelection = [for (int i = 0; i <= steps; i++) (anchorRow + stepRow * i, anchorCol + stepCol * i)];

    emit(state.copyWith(selection: newSelection));
  }

  FutureOr<void> _endSelection(EndSelection$WordSearchEvent event, Emitter<WordSearchState> emit) {
    if (state.selection.length < 2) {
      emit(state.copyWith(selection: []));
      return null;
    }

    final String letters = state.selection.map((p) => state.grid[p.$1][p.$2]).join();
    final String reversed = letters.split('').reversed.join();

    String? matched;
    for (final word in state.words) {
      if (state.foundWords.contains(word)) continue;
      if (word == letters || word == reversed) {
        matched = word;
        break;
      }
    }

    if (matched == null) {
      emit(state.copyWith(selection: []));
      return null;
    }

    final Set<String> newFoundWords = {...state.foundWords, matched};
    final Set<(int, int)> newFoundCells = {...state.foundCells, ...state.selection};
    final bool solved = newFoundWords.length == state.words.length;
    if (solved) unawaited(DailyChallengeService.notifyGameCompleted('wordSearch'));

    emit(state.copyWith(foundWords: newFoundWords, foundCells: newFoundCells, selection: [], isSolved: solved));
  }
}
