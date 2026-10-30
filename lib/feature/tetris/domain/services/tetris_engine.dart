import 'dart:math';

import 'package:grid_wars/feature/tetris/domain/entities/tetromino.dart';

/// Pure grid logic for Tetris — no Flutter/Flame dependency, directly
/// unit-testable. The Flame layer only ever calls [moveLeft]/[moveRight]/
/// [rotate]/[step]/[hardDrop] and reads [board]/[currentCells]/[ghostCells]
/// to render; every rule (collision, line clear, scoring) lives here.
class TetrisEngine {
  TetrisEngine({this.columns = 10, this.rows = 20, Random? random}) : _random = random ?? Random() {
    board = List.generate(rows, (_) => List<TetrominoType?>.filled(columns, null));
    nextType = _drawFromBag();
    _spawn();
  }

  final int columns;
  final int rows;
  final Random _random;
  final List<TetrominoType> _bag = [];

  late List<List<TetrominoType?>> board;
  late TetrominoType currentType;
  late TetrominoType nextType;
  late List<Point<int>> _currentShape;
  late Point<int> _origin;

  bool isGameOver = false;
  int score = 0;
  int linesCleared = 0;

  int get level => linesCleared ~/ 10 + 1;

  List<Point<int>> get currentCells => _currentShape.map((p) => Point(p.x + _origin.x, p.y + _origin.y)).toList();

  /// Where [currentCells] would land if dropped straight down from here —
  /// used to draw the landing preview ("ghost piece").
  List<Point<int>> get ghostCells {
    Point<int> origin = _origin;
    while (_fits(Point(origin.x, origin.y + 1), _currentShape)) {
      origin = Point(origin.x, origin.y + 1);
    }
    return _currentShape.map((p) => Point(p.x + origin.x, p.y + origin.y)).toList();
  }

  void reset() {
    board = List.generate(rows, (_) => List<TetrominoType?>.filled(columns, null));
    _bag.clear();
    score = 0;
    linesCleared = 0;
    isGameOver = false;
    nextType = _drawFromBag();
    _spawn();
  }

  bool moveLeft() => _tryMove(const Point(-1, 0));

  bool moveRight() => _tryMove(const Point(1, 0));

  void rotate() {
    if (isGameOver) return;
    final rotated = Tetromino.rotateCW(_currentShape);
    const kicks = [Point(0, 0), Point(1, 0), Point(-1, 0), Point(2, 0), Point(-2, 0)];
    for (final kick in kicks) {
      final kicked = Point(_origin.x + kick.x, _origin.y + kick.y);
      if (_fits(kicked, rotated)) {
        _currentShape = rotated;
        _origin = kicked;
        return;
      }
    }
  }

  /// Moves the piece down one row. Returns true if it moved, false if it
  /// landed (and was locked into the board).
  bool step() {
    if (isGameOver) return false;
    final down = Point(_origin.x, _origin.y + 1);
    if (_fits(down, _currentShape)) {
      _origin = down;
      return true;
    }
    _lock();
    return false;
  }

  void hardDrop() {
    if (isGameOver) return;
    while (_fits(Point(_origin.x, _origin.y + 1), _currentShape)) {
      _origin = Point(_origin.x, _origin.y + 1);
      score += 2;
    }
    _lock();
  }

  bool _tryMove(Point<int> delta) {
    if (isGameOver) return false;
    final newOrigin = Point(_origin.x + delta.x, _origin.y + delta.y);
    if (_fits(newOrigin, _currentShape)) {
      _origin = newOrigin;
      return true;
    }
    return false;
  }

  bool _fits(Point<int> origin, List<Point<int>> shape) {
    for (final cell in shape) {
      final x = origin.x + cell.x;
      final y = origin.y + cell.y;
      if (x < 0 || x >= columns || y >= rows) return false;
      if (y >= 0 && board[y][x] != null) return false;
    }
    return true;
  }

  TetrominoType _drawFromBag() {
    if (_bag.isEmpty) {
      _bag.addAll(TetrominoType.values);
      _bag.shuffle(_random);
    }
    return _bag.removeLast();
  }

  void _spawn() {
    currentType = nextType;
    nextType = _drawFromBag();
    _currentShape = Tetromino.cellsFor(currentType);
    _origin = Point(columns ~/ 2 - 2, 0);
    if (!_fits(_origin, _currentShape)) {
      isGameOver = true;
    }
  }

  void _lock() {
    for (final cell in currentCells) {
      if (cell.y >= 0 && cell.y < rows && cell.x >= 0 && cell.x < columns) {
        board[cell.y][cell.x] = currentType;
      }
    }
    final int cleared = _clearLines();
    if (cleared > 0) {
      linesCleared += cleared;
      score += switch (cleared) { 1 => 100, 2 => 300, 3 => 500, _ => 800 } * level;
    }
    _spawn();
  }

  int _clearLines() {
    final List<int> fullRows = [
      for (int y = 0; y < rows; y++)
        if (board[y].every((cell) => cell != null)) y,
    ];
    for (final y in fullRows.reversed) {
      board.removeAt(y);
    }
    for (int i = 0; i < fullRows.length; i++) {
      board.insert(0, List<TetrominoType?>.filled(columns, null));
    }
    return fullRows.length;
  }
}
