part of 'chess_bloc.dart';

sealed class ChessEvent {
  const ChessEvent();
}

class SelectSquare$ChessEvent extends ChessEvent {
  const SelectSquare$ChessEvent({required this.row, required this.col});

  final int row;
  final int col;
}

class SelectMode$ChessEvent extends ChessEvent {
  const SelectMode$ChessEvent({required this.mode});

  final GameMode mode;
}

class SelectDifficulty$ChessEvent extends ChessEvent {
  const SelectDifficulty$ChessEvent({required this.difficulty});

  final BotDifficulty difficulty;
}

class ResetGame$ChessEvent extends ChessEvent {
  const ResetGame$ChessEvent();
}

class RequestBotMove$ChessEvent extends ChessEvent {
  const RequestBotMove$ChessEvent();
}
