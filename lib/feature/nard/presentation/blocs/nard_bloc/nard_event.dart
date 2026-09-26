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
