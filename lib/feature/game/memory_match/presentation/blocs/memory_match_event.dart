part of 'memory_match_bloc.dart';

sealed class MemoryMatchEvent {
  const MemoryMatchEvent();
}

final class InitialData$MemoryMatchEvent extends MemoryMatchEvent {
  const InitialData$MemoryMatchEvent();
}

final class SelectCard$MemoryMatchEvent extends MemoryMatchEvent {
  const SelectCard$MemoryMatchEvent({required this.cardIndex});

  final int cardIndex;
}

final class ResetGame$MemoryMatchEvent extends MemoryMatchEvent {
  const ResetGame$MemoryMatchEvent();
}