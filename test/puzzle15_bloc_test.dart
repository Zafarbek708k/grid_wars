import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/puzzle15/presentation/blocs/puzzle15_bloc/puzzle15_bloc.dart';

bool _isSolvable(List<int> tiles, int size) {
  // Standard 15-puzzle solvability check via inversions + blank row parity.
  final List<int> withoutBlank = tiles.where((t) => t != 0).toList();
  int inversions = 0;
  for (int i = 0; i < withoutBlank.length; i++) {
    for (int j = i + 1; j < withoutBlank.length; j++) {
      if (withoutBlank[i] > withoutBlank[j]) inversions++;
    }
  }
  final int blankRowFromBottom = size - (tiles.indexOf(0) ~/ size);

  if (size.isOdd) {
    return inversions.isEven;
  } else {
    return (inversions + blankRowFromBottom).isOdd;
  }
}

/// Every Puzzle15Bloc fires an initial `SelectSize(size: 4)` from its own
/// constructor; tests await that first emission before doing anything else
/// so a later explicit event isn't racing it.
Future<Puzzle15State> _settled(Puzzle15Bloc bloc) => bloc.stream.first;

void main() {
  group('Puzzle15Bloc', () {
    test('shuffled board for every size is solvable', () async {
      for (final size in [4, 5, 6]) {
        final bloc = Puzzle15Bloc(random: Random(size));
        await _settled(bloc);

        final future = bloc.stream.first;
        bloc.add(SelectSize$Puzzle15Event(size: size));
        final state = await future;

        expect(state.size, size);
        expect(_isSolvable(state.tiles, size), isTrue, reason: 'size=$size');
        await bloc.close();
      }
    });

    test('tapping a tile not adjacent to the blank does nothing', () async {
      final bloc = Puzzle15Bloc(random: Random(42));
      await _settled(bloc);

      final initialTiles = List<int>.from(bloc.state.tiles);
      final blank = initialTiles.indexOf(0);
      final farIndex = blank == 0 ? initialTiles.length - 1 : 0;

      bloc.add(TapTile$Puzzle15Event(index: farIndex));
      // The tap is a no-op, so give it a turn through the event loop and
      // assert nothing changed rather than waiting on a state that never
      // arrives.
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.tiles, initialTiles);
      expect(bloc.state.moves, 0);
      await bloc.close();
    });

    test('sliding a tile into the blank swaps them and increments moves', () async {
      final bloc = Puzzle15Bloc(random: Random(7));
      await _settled(bloc);

      final int size = bloc.state.size;
      final int blank = bloc.state.tiles.indexOf(0);
      final int col = blank % size;
      final int adjacentIndex = col > 0 ? blank - 1 : blank + 1;
      final int movedValue = bloc.state.tiles[adjacentIndex];

      final future = bloc.stream.first;
      bloc.add(TapTile$Puzzle15Event(index: adjacentIndex));
      final state = await future;

      expect(state.moves, 1);
      expect(state.tiles[blank], movedValue);
      expect(state.tiles[adjacentIndex], 0);
      await bloc.close();
    });
  });
}
