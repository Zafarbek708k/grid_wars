part of 'nard_bloc.dart';

sealed class NardEvent {
  const NardEvent();
}

class RollDice$NardEvent extends NardEvent {
  const RollDice$NardEvent();
}

class ResetGame$NardEvent extends NardEvent {
  const ResetGame$NardEvent();
}

class SelectMode$NardEvent extends NardEvent {
  final GameMode mode;

  const SelectMode$NardEvent({required this.mode});
}

/// Internal event: scheduled a short delay after the human's roll so the
/// bot's turn doesn't resolve instantly.
class RequestBotRoll$NardEvent extends NardEvent {
  const RequestBotRoll$NardEvent();
}
