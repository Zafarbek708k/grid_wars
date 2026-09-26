part of 'puzzle15_bloc.dart';

sealed class Puzzle15Event {
  const Puzzle15Event();
}

class SelectSize$Puzzle15Event extends Puzzle15Event {
  final int size;

  const SelectSize$Puzzle15Event({required this.size});
}

class TapTile$Puzzle15Event extends Puzzle15Event {
  final int index;

  const TapTile$Puzzle15Event({required this.index});
}

class ResetGame$Puzzle15Event extends Puzzle15Event {
  const ResetGame$Puzzle15Event();
}
