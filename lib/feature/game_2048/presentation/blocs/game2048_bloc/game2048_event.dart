part of 'game2048_bloc.dart';

sealed class Game2048Event {
  const Game2048Event();
}

class NewGame$Game2048Event extends Game2048Event {
  const NewGame$Game2048Event();
}

class Move$Game2048Event extends Game2048Event {
  final SwipeDirection direction;

  const Move$Game2048Event({required this.direction});
}
