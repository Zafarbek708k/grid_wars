part of 'minesweeper_bloc.dart';

class MinesweeperState extends Equatable {
  final MinesweeperDifficulty difficulty;
  final List<List<MineCell>> board;
  final bool firstClickDone;
  final bool isGameOver;
  final bool isWin;

  const MinesweeperState({
    this.difficulty = MinesweeperDifficulty.beginner,
    this.board = const [],
    this.firstClickDone = false,
    this.isGameOver = false,
    this.isWin = false,
  });

  int get flaggedCount => MinesweeperEngine.flaggedCount(board);

  MinesweeperState copyWith({
    MinesweeperDifficulty? difficulty,
    List<List<MineCell>>? board,
    bool? firstClickDone,
    bool? isGameOver,
    bool? isWin,
  }) {
    return MinesweeperState(
      difficulty: difficulty ?? this.difficulty,
      board: board ?? this.board,
      firstClickDone: firstClickDone ?? this.firstClickDone,
      isGameOver: isGameOver ?? this.isGameOver,
      isWin: isWin ?? this.isWin,
    );
  }

  @override
  List<Object?> get props => [difficulty, board, firstClickDone, isGameOver, isWin];
}
