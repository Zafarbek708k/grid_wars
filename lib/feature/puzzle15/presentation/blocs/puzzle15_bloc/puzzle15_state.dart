part of 'puzzle15_bloc.dart';

class Puzzle15State extends Equatable {
  final int size;
  final List<int> tiles;
  final int moves;
  final bool isSolved;
  final int elapsedSeconds;

  const Puzzle15State({
    this.size = 4,
    this.tiles = const [],
    this.moves = 0,
    this.isSolved = false,
    this.elapsedSeconds = 0,
  });

  Puzzle15State copyWith({
    int? size,
    List<int>? tiles,
    int? moves,
    bool? isSolved,
    int? elapsedSeconds,
  }) {
    return Puzzle15State(
      size: size ?? this.size,
      tiles: tiles ?? this.tiles,
      moves: moves ?? this.moves,
      isSolved: isSolved ?? this.isSolved,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  @override
  List<Object?> get props => [size, tiles, moves, isSolved, elapsedSeconds];
}
