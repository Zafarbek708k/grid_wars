part of 'x_o_bloc.dart';

sealed class XOEvent extends Equatable {
  const XOEvent();
}

class TabEvent extends XOEvent {
  final int index;

  const TabEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ResetGameEvent extends XOEvent {
  const ResetGameEvent();

  @override
  List<Object?> get props => [];
}

class SelectMode$XOEvent extends XOEvent {
  final GameMode mode;

  const SelectMode$XOEvent({required this.mode});

  @override
  List<Object?> get props => [mode];
}

class SelectDifficulty$XOEvent extends XOEvent {
  final BotDifficulty difficulty;

  const SelectDifficulty$XOEvent({required this.difficulty});

  @override
  List<Object?> get props => [difficulty];
}

/// Internal event: scheduled a short "thinking" delay after the human's
/// move so the bot's reply doesn't appear instantly.
class RequestBotMove$XOEvent extends XOEvent {
  const RequestBotMove$XOEvent();

  @override
  List<Object?> get props => [];
}
