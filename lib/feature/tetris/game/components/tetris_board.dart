import 'dart:ui';

import 'package:flame/components.dart';

import 'package:grid_wars/feature/tetris/domain/entities/tetromino.dart';
import 'package:grid_wars/feature/tetris/domain/services/tetris_engine.dart';

/// Draws the whole board — grid, locked cells, ghost piece, falling piece —
/// in one render pass reading straight from [engine]'s current state.
class TetrisBoard extends PositionComponent {
  TetrisBoard({required this.engine, required this.cellSize});

  final TetrisEngine engine;
  final double cellSize;

  static const Map<TetrominoType, Color> _colors = {
    TetrominoType.i: Color(0xFF26C6DA),
    TetrominoType.o: Color(0xFFFDD835),
    TetrominoType.t: Color(0xFFAB47BC),
    TetrominoType.s: Color(0xFF66BB6A),
    TetrominoType.z: Color(0xFFEF5350),
    TetrominoType.j: Color(0xFF42A5F5),
    TetrominoType.l: Color(0xFFFFA726),
  };

  @override
  void render(Canvas canvas) {
    _renderGrid(canvas);
    _renderLockedCells(canvas);
    _renderGhost(canvas);
    _renderCurrentPiece(canvas);
  }

  void _renderGrid(Canvas canvas) {
    final Paint line = Paint()..color = const Color(0x0FFFFFFF);
    for (int col = 0; col <= engine.columns; col++) {
      final double x = col * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, engine.rows * cellSize), line);
    }
    for (int row = 0; row <= engine.rows; row++) {
      final double y = row * cellSize;
      canvas.drawLine(Offset(0, y), Offset(engine.columns * cellSize, y), line);
    }
  }

  void _renderLockedCells(Canvas canvas) {
    for (int y = 0; y < engine.rows; y++) {
      for (int x = 0; x < engine.columns; x++) {
        final type = engine.board[y][x];
        if (type != null) _drawCell(canvas, x, y, _colors[type]!);
      }
    }
  }

  void _renderGhost(Canvas canvas) {
    final Paint paint = Paint()
      ..color = _colors[engine.currentType]!.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final cell in engine.ghostCells) {
      if (cell.y < 0) continue;
      canvas.drawRect(Rect.fromLTWH(cell.x * cellSize + 2, cell.y * cellSize + 2, cellSize - 4, cellSize - 4), paint);
    }
  }

  void _renderCurrentPiece(Canvas canvas) {
    final Color color = _colors[engine.currentType]!;
    for (final cell in engine.currentCells) {
      if (cell.y < 0) continue;
      _drawCell(canvas, cell.x, cell.y, color);
    }
  }

  void _drawCell(Canvas canvas, int x, int y, Color color) {
    final Rect rect = Rect.fromLTWH(x * cellSize + 1, y * cellSize + 1, cellSize - 2, cellSize - 2);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.18)), Paint()..color = color);
  }
}
