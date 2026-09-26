part of 'memory_match_bloc.dart';

class MemoryMatchState extends Equatable {
  const MemoryMatchState({
    this.memoryCards = const [],
    this.selectedCardIndex = -1,
    this.blockButton = false,
    this.isWin = false,
  });

  final List<MemoryCard> memoryCards;
  final int selectedCardIndex;
  final bool blockButton;
  final bool isWin;

  MemoryMatchState copyWith({List<MemoryCard>? memoryCards, int? selectedCardIndex, bool? blockButton, bool? isWin}) {
    return MemoryMatchState(
      memoryCards: memoryCards ?? this.memoryCards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      blockButton: blockButton ?? this.blockButton,
      isWin: isWin ?? this.isWin,
    );
  }

  @override
  List<Object?> get props => [memoryCards, selectedCardIndex, blockButton, isWin];
}
