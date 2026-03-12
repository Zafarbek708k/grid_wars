part of 'x_o_bloc.dart';

class XOState extends Equatable {
  final List<GameItemTypeEnum> board;
  final GameItemTypeEnum currentPlayer;
  final String? winner;
  final bool isGameOver;
  final List<int> winningLine;

  const XOState({
    this.board = const [
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
      GameItemTypeEnum.empty,
    ],
    this.currentPlayer = GameItemTypeEnum.x,
    this.winner,
    this.isGameOver = false,
    this.winningLine = const [],
  });

  XOState copyWith({
    List<GameItemTypeEnum>? board,
    GameItemTypeEnum? currentPlayer,
    String? winner,
    bool? isGameOver,
    List<int>? winningLine,
  }) {
    return XOState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      winner: winner ?? this.winner,
      isGameOver: isGameOver ?? this.isGameOver,
      winningLine: winningLine ?? this.winningLine,
    );
  }

  @override
  List<Object?> get props => [board, currentPlayer, winner, isGameOver, winningLine];
}
