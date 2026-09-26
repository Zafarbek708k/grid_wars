import 'dart:math';

import 'package:grid_wars/feature/word_search/domain/entities/word_search_puzzle.dart';

/// Pure Word Search generation logic: places a random subset of a themed
/// word bank into a grid in one of 8 directions, then fills the remaining
/// cells with random letters. Free of Bloc/Flutter so it can be
/// unit-tested directly.
class WordSearchGenerator {
  WordSearchGenerator._();

  static const List<String> wordBank = [
    'SUN', 'MOON', 'STAR', 'MARS', 'EARTH', 'COMET', 'ORBIT', 'ROCKET', 'PLANET', 'VENUS', 'SATURN', 'GALAXY',
  ];

  static const List<(int, int)> _directions = [
    (0, 1), (0, -1), (1, 0), (-1, 0),
    (1, 1), (1, -1), (-1, 1), (-1, -1),
  ];

  static WordSearchPuzzle generate({int size = 10, int wordCount = 6, Random? random}) {
    final rnd = random ?? Random();
    final List<List<String>> grid = List.generate(size, (_) => List.filled(size, ''));

    final List<String> candidates = List<String>.from(wordBank)..shuffle(rnd);
    final List<String> placedWords = [];

    for (final word in candidates) {
      if (placedWords.length >= wordCount) break;
      if (word.length > size) continue;
      if (_tryPlace(grid, word, rnd)) {
        placedWords.add(word);
      }
    }

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c].isEmpty) {
          grid[r][c] = String.fromCharCode(65 + rnd.nextInt(26));
        }
      }
    }

    return WordSearchPuzzle(grid: grid, words: placedWords);
  }

  static bool _tryPlace(List<List<String>> grid, String word, Random random) {
    final int size = grid.length;

    for (int attempt = 0; attempt < 200; attempt++) {
      final (dRow, dCol) = _directions[random.nextInt(_directions.length)];
      final int startRow = random.nextInt(size);
      final int startCol = random.nextInt(size);
      final int endRow = startRow + dRow * (word.length - 1);
      final int endCol = startCol + dCol * (word.length - 1);

      if (endRow < 0 || endRow >= size || endCol < 0 || endCol >= size) continue;

      bool fits = true;
      for (int i = 0; i < word.length; i++) {
        final String existing = grid[startRow + dRow * i][startCol + dCol * i];
        if (existing.isNotEmpty && existing != word[i]) {
          fits = false;
          break;
        }
      }
      if (!fits) continue;

      for (int i = 0; i < word.length; i++) {
        grid[startRow + dRow * i][startCol + dCol * i] = word[i];
      }
      return true;
    }

    return false;
  }
}
