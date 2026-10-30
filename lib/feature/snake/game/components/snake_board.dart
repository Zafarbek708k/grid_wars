import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import 'package:grid_wars/feature/snake/domain/entities/direction.dart';
import 'package:grid_wars/feature/snake/domain/services/snake_engine.dart';

/// Draws the whole board — grid, snake, food — in one render pass reading
/// straight from [engine]'s current state. No per-cell child components or
/// hitboxes: grid-based collision is plain coordinate math in [SnakeEngine],
/// so there's nothing here for Flame's collision system to do.
class SnakeBoard extends PositionComponent {
  SnakeBoard({required this.engine, required this.cellSize});

  final SnakeEngine engine;
  final double cellSize;

  double _pulseTime = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _pulseTime += dt;
  }

  @override
  void render(Canvas canvas) {
    _renderGrid(canvas);
    _renderFood(canvas);
    _renderSnake(canvas);
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

  void _renderFood(Canvas canvas) {
    final Offset center = Offset(
      (engine.food.x + 0.5) * cellSize,
      (engine.food.y + 0.5) * cellSize,
    );
    final double pulse = 0.5 + 0.5 * math.sin(_pulseTime * 4);
    final double radius = cellSize * (0.3 + pulse * 0.08);

    canvas.drawCircle(center, cellSize * 0.55, Paint()..color = const Color(0x33FF5252));
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFFF5252));
  }

  void _renderSnake(Canvas canvas) {
    final int length = engine.body.length;
    for (int i = length - 1; i >= 0; i--) {
      final point = engine.body[i];
      final double t = length <= 1 ? 0 : i / (length - 1);
      final Color color = Color.lerp(const Color(0xFF69F0AE), const Color(0xFF1B5E20), t)!;
      final Rect rect = Rect.fromLTWH(
        point.x * cellSize + 1,
        point.y * cellSize + 1,
        cellSize - 2,
        cellSize - 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.28)),
        Paint()..color = color,
      );
    }

    if (engine.body.isNotEmpty) {
      _renderEyes(canvas, engine.body.first, engine.direction);
    }
  }

  void _renderEyes(Canvas canvas, math.Point<int> head, Direction direction) {
    final double cx = (head.x + 0.5) * cellSize;
    final double cy = (head.y + 0.5) * cellSize;
    // Perpendicular to the travel direction, so the two eyes sit side by
    // side facing forward regardless of which way the head is pointed.
    final double forwardX = direction.dx * cellSize * 0.15;
    final double forwardY = direction.dy * cellSize * 0.15;
    final double perpX = -direction.dy * cellSize * 0.2;
    final double perpY = direction.dx * cellSize * 0.2;

    final Paint eyePaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawCircle(Offset(cx + forwardX + perpX, cy + forwardY + perpY), cellSize * 0.09, eyePaint);
    canvas.drawCircle(Offset(cx + forwardX - perpX, cy + forwardY - perpY), cellSize * 0.09, eyePaint);
  }
}
