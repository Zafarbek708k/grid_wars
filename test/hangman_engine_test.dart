import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/hangman/domain/services/hangman_engine.dart';

void main() {
  group('HangmanEngine', () {
    test('wrongGuessCount only counts letters absent from the word', () {
      expect(HangmanEngine.wrongGuessCount('CAT', {'C', 'X', 'A', 'Z'}), 2);
    });

    test('isWin is true once every letter of the word has been guessed', () {
      expect(HangmanEngine.isWin('CAT', {'C', 'A', 'T'}), isTrue);
      expect(HangmanEngine.isWin('CAT', {'C', 'A'}), isFalse);
    });

    test('isWin is false for an empty word (no game started yet)', () {
      expect(HangmanEngine.isWin('', {}), isFalse);
    });

    test('isLoss is true once wrong guesses reach the max', () {
      final wrong = {'Q', 'X', 'Z', 'J', 'V', 'K'};
      expect(wrong.length, HangmanEngine.maxWrongGuesses);
      expect(HangmanEngine.isLoss('CAT', wrong), isTrue);
      expect(HangmanEngine.isLoss('CAT', {'Q', 'X'}), isFalse);
    });

    test('maskedWord reveals only guessed letters', () {
      expect(HangmanEngine.maskedWord('CAT', {'C'}), 'C__');
      expect(HangmanEngine.maskedWord('CAT', {'C', 'A', 'T'}), 'CAT');
      expect(HangmanEngine.maskedWord('CAT', {}), '___');
    });
  });
}
