/// Pure rules for Hangman — no Flutter/Bloc dependency, directly
/// unit-testable. Operates on plain (word, guessedLetters) pairs rather
/// than holding state itself, since [HangmanState] already stores exactly
/// that and derives everything else from it.
class HangmanEngine {
  const HangmanEngine._();

  static const int maxWrongGuesses = 6;

  static int wrongGuessCount(String word, Set<String> guessedLetters) {
    return guessedLetters.where((letter) => !word.contains(letter)).length;
  }

  static bool isWin(String word, Set<String> guessedLetters) {
    if (word.isEmpty) return false;
    return word.split('').every(guessedLetters.contains);
  }

  static bool isLoss(String word, Set<String> guessedLetters) {
    return wrongGuessCount(word, guessedLetters) >= maxWrongGuesses;
  }

  static String maskedWord(String word, Set<String> guessedLetters) {
    return word.split('').map((letter) => guessedLetters.contains(letter) ? letter : '_').join();
  }
}
