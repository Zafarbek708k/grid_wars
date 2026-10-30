import 'dart:ui';

import 'package:flame/components.dart';

import 'package:grid_wars/feature/bubble_shooter/domain/entities/bubble_color.dart';
import 'package:grid_wars/feature/bubble_shooter/game/bubble_shooter_game.dart';

/// Draws the whole scene — grid bubbles, danger line, aim line, shooter
/// bubble, flying projectile — in one render pass reading straight from
/// [game]'s current state.
class BubbleBoardView extends PositionComponent with HasGameReference<BubbleShooterGame> {
  static const Map<BubbleColor, Color> colors = {
    BubbleColor.red: Color(0xFFEF5350),
    BubbleColor.blue: Color(0xFF42A5F5),
    BubbleColor.green: Color(0xFF66BB6A),
    BubbleColor.yellow: Color(0xFFFDD835),
    BubbleColor.purple: Color(0xFFAB47BC),
  };

  @override
  void render(Canvas canvas) {
    _renderDangerLine(canvas);
    _renderGrid(canvas);
    _renderAimLine(canvas);
    _renderShooter(canvas);
    _renderProjectile(canvas);
  }

  void _renderDangerLine(Canvas canvas) {
    final double y = game.engine.dangerRow * game.layout.rowHeight;
    final Paint paint = Paint()
      ..color = const Color(0x55FF5252)
      ..strokeWidth = 2;
    const double dash = 8;
    for (double x = 0; x < game.size.x; x += dash * 2) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
    }
  }

  void _renderGrid(Canvas canvas) {
    final engine = game.engine;
    for (int row = 0; row < engine.rows; row++) {
      for (int col = 0; col < engine.columns; col++) {
        final color = engine.grid[row][col];
        if (color == null) continue;
        final (cx, cy) = game.layout.cellCenter(row, col);
        canvas.drawCircle(Offset(cx, cy), game.layout.cellSize * 0.46, Paint()..color = colors[color]!);
      }
    }
  }

  void _renderAimLine(Canvas canvas) {
    final direction = game.aimDirection;
    if (direction == null) return;
    final start = game.shooterPosition;
    final end = start + direction * 120;
    final Paint paint = Paint()
      ..color = const Color(0x88FFFFFF)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(start.x, start.y), Offset(end.x, end.y), paint);
  }

  void _renderShooter(Canvas canvas) {
    final pos = game.shooterPosition;
    canvas.drawCircle(
      Offset(pos.x, pos.y),
      game.layout.cellSize * 0.46,
      Paint()..color = colors[game.engine.currentColor]!,
    );
  }

  void _renderProjectile(Canvas canvas) {
    final pos = game.projectilePosition;
    if (pos == null) return;
    canvas.drawCircle(Offset(pos.x, pos.y), game.layout.cellSize * 0.46, Paint()..color = colors[game.engine.currentColor]!);
  }
}
