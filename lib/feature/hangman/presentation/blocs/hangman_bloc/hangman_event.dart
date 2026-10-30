part of 'hangman_bloc.dart';

sealed class HangmanEvent {
  const HangmanEvent();
}

class GuessLetter$HangmanEvent extends HangmanEvent {
  const GuessLetter$HangmanEvent({required this.letter});

  final String letter;
}

class NewGame$HangmanEvent extends HangmanEvent {
  const NewGame$HangmanEvent();
}
