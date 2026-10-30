import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/bubble_shooter/domain/services/bubble_grid_layout.dart';

void main() {
  group('BubbleGridLayout', () {
    const layout = BubbleGridLayout(columns: 8, cellSize: 40);

    test('rowHeight is shorter than cellSize (hex-packed rows overlap vertically)', () {
      expect(layout.rowHeight, lessThan(layout.cellSize));
    });

    test('odd rows are offset right by half a cell compared to even rows', () {
      final (evenX, _) = layout.cellCenter(0, 2);
      final (oddX, _) = layout.cellCenter(1, 2);
      expect(oddX - evenX, closeTo(layout.cellSize / 2, 0.001));
    });

    test('nearestCell finds the exact cell for its own center pixel', () {
      final (cx, cy) = layout.cellCenter(3, 4);
      expect(layout.nearestCell(cx, cy), (3, 4));
    });

    test('nearestCell finds the exact cell for an odd-row center pixel too', () {
      final (cx, cy) = layout.cellCenter(5, 2);
      expect(layout.nearestCell(cx, cy), (5, 2));
    });
  });
}
