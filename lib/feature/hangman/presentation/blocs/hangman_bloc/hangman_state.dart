part of 'hangman_bloc.dart';

class HangmanState extends Equatable {
  const HangmanState({this.word = '', this.hint = '', this.guessedLetters = const {}});

  final String word;
  final String hint;
  final Set<String> guessedLetters;

  int get wrongGuessCount => HangmanEngine.wrongGuessCount(word, guessedLetters);

  bool get isWin => HangmanEngine.isWin(word, guessedLetters);

  bool get isLoss => HangmanEngine.isLoss(word, guessedLetters);

  bool get isGameOver => isWin || isLoss;

  String get maskedWord => HangmanEngine.maskedWord(word, guessedLetters);

  HangmanState copyWith({String? word, String? hint, Set<String>? guessedLetters}) {
    return HangmanState(
      word: word ?? this.word,
      hint: hint ?? this.hint,
      guessedLetters: guessedLetters ?? this.guessedLetters,
    );
  }

  @override
  List<Object?> get props => [word, hint, guessedLetters];
}
