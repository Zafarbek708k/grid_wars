import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'puzzle15_event.dart';
part 'puzzle15_state.dart';

/// Classic sliding tile puzzle, playable on 4x4 (15-puzzle), 5x5 (24-puzzle)
/// and 6x6 (35-puzzle) boards. Tile `0` is the blank slot.
class Puzzle15Bloc extends Bloc<Puzzle15Event, Puzzle15State> {
  Puzzle15Bloc({Random? random}) : _random = random ?? Random(), super(const Puzzle15State()) {
    on<SelectSize$Puzzle15Event>(_selectSize);
    on<TapTile$Puzzle15Event>(_tapTile);
    on<ResetGame$Puzzle15Event>(_resetGame);

    add(const SelectSize$Puzzle15Event(size: 4));
  }

  final Random _random;
  DateTime? _startedAt;

  FutureOr<void> _selectSize(SelectSize$Puzzle15Event event, Emitter<Puzzle15State> emit) {
    _startedAt = DateTime.now();
    emit(
      Puzzle15State(
        size: event.size,
        tiles: _shuffledTiles(event.size),
        moves: 0,
        isSolved: false,
        elapsedSeconds: 0,
      ),
    );
  }

  FutureOr<void> _resetGame(ResetGame$Puzzle15Event event, Emitter<Puzzle15State> emit) {
    _startedAt = DateTime.now();
    emit(state.copyWith(tiles: _shuffledTiles(state.size), moves: 0, isSolved: false, elapsedSeconds: 0));
  }

  FutureOr<void> _tapTile(TapTile$Puzzle15Event event, Emitter<Puzzle15State> emit) {
    if (state.isSolved) return null;

    final int size = state.size;
    final int blankIndex = state.tiles.indexOf(0);
    if (!_isAdjacent(event.index, blankIndex, size)) return null;

    final List<int> newTiles = List<int>.from(state.tiles);
    newTiles[blankIndex] = newTiles[event.index];
    newTiles[event.index] = 0;

    final bool solved = _isSolved(newTiles);
    final int elapsed = solved && _startedAt != null ? DateTime.now().difference(_startedAt!).inSeconds : state.elapsedSeconds;

    emit(state.copyWith(tiles: newTiles, moves: state.moves + 1, isSolved: solved, elapsedSeconds: elapsed));
  }

  bool _isAdjacent(int a, int b, int size) {
    final int rowA = a ~/ size, colA = a % size;
    final int rowB = b ~/ size, colB = b % size;
    return (rowA == rowB && (colA - colB).abs() == 1) || (colA == colB && (rowA - rowB).abs() == 1);
  }

  List<int> _solvedTiles(int size) => [...List.generate(size * size - 1, (i) => i + 1), 0];

  bool _isSolved(List<int> tiles) {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }

  /// Shuffles by replaying random *valid* slides from the solved state, so
  /// the result is always solvable (unlike a raw random permutation, which
  /// is only solvable half the time).
  List<int> _shuffledTiles(int size) {
    final List<int> tiles = _solvedTiles(size);
    int blankIndex = tiles.length - 1;
    final int shuffleMoves = size * size * 40;

    for (int i = 0; i < shuffleMoves; i++) {
      final List<int> candidates = _adjacentIndices(blankIndex, size);
      final int swapWith = candidates[_random.nextInt(candidates.length)];
      tiles[blankIndex] = tiles[swapWith];
      tiles[swapWith] = 0;
      blankIndex = swapWith;
    }

    if (_isSolved(tiles)) {
      return _shuffledTiles(size);
    }
    return tiles;
  }

  List<int> _adjacentIndices(int index, int size) {
    final int row = index ~/ size, col = index % size;
    final List<int> result = [];
    if (row > 0) result.add(index - size);
    if (row < size - 1) result.add(index + size);
    if (col > 0) result.add(index - 1);
    if (col < size - 1) result.add(index + 1);
    return result;
  }
}
