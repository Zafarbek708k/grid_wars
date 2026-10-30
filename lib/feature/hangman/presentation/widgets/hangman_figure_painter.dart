import 'package:flutter/material.dart';

/// Draws the gallows plus a progressively-built stick figure, one body
/// part per wrong guess (head, body, two arms, two legs — 6 parts total,
/// matching [HangmanEngine.maxWrongGuesses]).
class HangmanFigurePainter extends CustomPainter {
  const HangmanFigurePainter({required this.wrongGuessCount, required this.color});

  final int wrongGuessCount;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035
      ..strokeCap = StrokeCap.round;

    final double w = size.width;
    final double h = size.height;

    // Gallows — always visible.
    canvas.drawLine(Offset(w * 0.1, h * 0.95), Offset(w * 0.6, h * 0.95), paint);
    canvas.drawLine(Offset(w * 0.25, h * 0.95), Offset(w * 0.25, h * 0.05), paint);
    canvas.drawLine(Offset(w * 0.25, h * 0.05), Offset(w * 0.65, h * 0.05), paint);
    canvas.drawLine(Offset(w * 0.25, h * 0.2), Offset(w * 0.4, h * 0.05), paint);
    canvas.drawLine(Offset(w * 0.65, h * 0.05), Offset(w * 0.65, h * 0.18), paint);

    final double headCx = w * 0.65;
    final double headCy = h * 0.27;
    final double headR = w * 0.09;

    if (wrongGuessCount >= 1) {
      canvas.drawCircle(Offset(headCx, headCy), headR, paint);
    }
    if (wrongGuessCount >= 2) {
      canvas.drawLine(Offset(headCx, headCy + headR), Offset(headCx, h * 0.62), paint);
    }
    if (wrongGuessCount >= 3) {
      canvas.drawLine(Offset(headCx, h * 0.4), Offset(headCx - w * 0.15, h * 0.5), paint);
    }
    if (wrongGuessCount >= 4) {
      canvas.drawLine(Offset(headCx, h * 0.4), Offset(headCx + w * 0.15, h * 0.5), paint);
    }
    if (wrongGuessCount >= 5) {
      canvas.drawLine(Offset(headCx, h * 0.62), Offset(headCx - w * 0.15, h * 0.85), paint);
    }
    if (wrongGuessCount >= 6) {
      canvas.drawLine(Offset(headCx, h * 0.62), Offset(headCx + w * 0.15, h * 0.85), paint);
    }
  }

  @override
  bool shouldRepaint(covariant HangmanFigurePainter oldDelegate) {
    return oldDelegate.wrongGuessCount != wrongGuessCount || oldDelegate.color != color;
  }
}
