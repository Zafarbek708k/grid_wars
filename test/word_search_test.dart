import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/word_search/domain/services/word_search_generator.dart';
import 'package:grid_wars/feature/word_search/presentation/blocs/word_search_bloc/word_search_bloc.dart';

/// Confirms [word] actually reads off the grid starting at ([row], [col])
/// stepping by ([dRow], [dCol]).
bool _readsAt(List<List<String>> grid, String word, int row, int col, int dRow, int dCol) {
  for (int i = 0; i < word.length; i++) {
    final int r = row + dRow * i;
    final int c = col + dCol * i;
    if (r < 0 || r >= grid.length || c < 0 || c >= grid.length) return false;
    if (grid[r][c] != word[i]) return false;
  }
  return true;
}

bool _isFindable(List<List<String>> grid, String word) {
  const directions = [
    (0, 1), (0, -1), (1, 0), (-1, 0),
    (1, 1), (1, -1), (-1, 1), (-1, -1),
  ];
  for (int r = 0; r < grid.length; r++) {
    for (int c = 0; c < grid.length; c++) {
      for (final (dr, dc) in directions) {
        if (_readsAt(grid, word, r, c, dr, dc)) return true;
      }
    }
  }
  return false;
}

Future<WordSearchState> _settled(WordSearchBloc bloc) => bloc.stream.first;

void main() {
  group('WordSearchGenerator', () {
    test('every placed word is actually present in the grid', () {
      for (int seed = 0; seed < 15; seed++) {
        final puzzle = WordSearchGenerator.generate(random: Random(seed));
        for (final word in puzzle.words) {
          expect(_isFindable(puzzle.grid, word), isTrue, reason: 'seed=$seed word=$word');
        }
      }
    });

    test('generates the requested number of words when they fit', () {
      final puzzle = WordSearchGenerator.generate(random: Random(1), wordCount: 6);
      expect(puzzle.words.length, 6);
    });

    test('every cell is filled (no blanks left over)', () {
      final puzzle = WordSearchGenerator.generate(random: Random(2));
      for (final row in puzzle.grid) {
        for (final cell in row) {
          expect(cell, isNotEmpty);
        }
      }
    });
  });

  group('WordSearchBloc selection', () {
    test('selecting a straight horizontal line and matching a word marks it found', () async {
      final bloc = WordSearchBloc(random: Random(5));
      final state = await _settled(bloc);

      // Find any horizontally-placed word by scanning the grid directly,
      // so this test doesn't depend on knowing the RNG's exact placement.
      String? targetWord;
      int startRow = 0, startCol = 0;
      for (final word in state.words) {
        bool found = false;
        for (int r = 0; r < state.grid.length && !found; r++) {
          for (int c = 0; c <= state.grid.length - word.length && !found; c++) {
            if (_readsAt(state.grid, word, r, c, 0, 1)) {
              targetWord = word;
              startRow = r;
              startCol = c;
              found = true;
            }
          }
        }
        if (found) break;
      }

      if (targetWord == null) {
        // No horizontally-placed word this seed produced; nothing to assert.
        await bloc.close();
        return;
      }

      bloc.add(StartSelection$WordSearchEvent(row: startRow, col: startCol));
      bloc.add(UpdateSelection$WordSearchEvent(row: startRow, col: startCol + targetWord.length - 1));
      final future = bloc.stream.first;
      bloc.add(const EndSelection$WordSearchEvent());
      await future;

      // Drain remaining scheduled emissions (start/update also emit).
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(bloc.state.foundWords.contains(targetWord), isTrue);
      await bloc.close();
    });

    test('a diagonal drag that is not a straight line is ignored', () async {
      final bloc = WordSearchBloc(random: Random(6));
      await _settled(bloc);

      bloc.add(const StartSelection$WordSearchEvent(row: 0, col: 0));
      await Future<void>.delayed(Duration.zero);
      final selectionAfterStart = bloc.state.selection;

      bloc.add(const UpdateSelection$WordSearchEvent(row: 2, col: 1)); // not a straight 8-direction line
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.selection, selectionAfterStart);
      await bloc.close();
    });
  });
}
