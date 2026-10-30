import 'dart:math' as math;

/// Pixel <-> grid-cell conversion for a hex-staggered ("odd-r offset")
/// bubble grid — odd rows are shifted right by half a cell so bubbles pack
/// hexagonally instead of in a plain square grid. Pure math, no Flutter
/// dependency, so it's unit-testable on its own.
class BubbleGridLayout {
  const BubbleGridLayout({required this.columns, required this.cellSize});

  final int columns;
  final double cellSize;

  /// Hex-packed rows overlap vertically by the classic sqrt(3)/2 ratio.
  double get rowHeight => cellSize * 0.87;

  (double, double) cellCenter(int row, int col) {
    final double xOffset = row.isOdd ? cellSize / 2 : 0;
    final double x = col * cellSize + cellSize / 2 + xOffset;
    final double y = row * rowHeight + cellSize / 2;
    return (x, y);
  }

  /// The grid cell whose center is nearest to a pixel position, searching
  /// only the rows immediately around the approximate row for [y].
  (int, int) nearestCell(double x, double y) {
    final int approxRow = math.max(0, (y / rowHeight).round());
    (int, int)? best;
    double bestDistSq = double.infinity;

    for (int row = math.max(0, approxRow - 1); row <= approxRow + 1; row++) {
      for (int col = 0; col < columns; col++) {
        final (cx, cy) = cellCenter(row, col);
        final double distSq = (cx - x) * (cx - x) + (cy - y) * (cy - y);
        if (distSq < bestDistSq) {
          bestDistSq = distSq;
          best = (row, col);
        }
      }
    }
    return best!;
  }
}
