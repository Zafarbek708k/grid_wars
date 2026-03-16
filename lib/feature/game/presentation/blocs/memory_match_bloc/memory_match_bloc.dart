import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:grid_wars/core/constants/app_images.dart';
import 'package:grid_wars/feature/game/domain/entities/memory_card.dart';

part 'memory_match_event.dart';
part 'memory_match_state.dart';

class MemoryMatchBloc extends Bloc<MemoryMatchEvent, MemoryMatchState> {
  MemoryMatchBloc() : super(const MemoryMatchState()) {
    on<MemoryMatchEvent>(
      (event, emit) => switch (event) {
        SelectCard$MemoryMatchEvent _ => _selectCard(event, emit),
        InitialData$MemoryMatchEvent _ => _initialData(event, emit),
        ResetGame$MemoryMatchEvent _ => _resetGame(event, emit),
      },
    );

    add(InitialData$MemoryMatchEvent());
  }

  void _initialData(InitialData$MemoryMatchEvent event, Emitter<MemoryMatchState> emit) {
    _memoryCards.shuffle();

    List<MemoryCard> memoryCards = _memoryCards.sublist(0, 8);
    memoryCards = [...memoryCards, ...memoryCards]..shuffle();

    emit(state.copyWith(memoryCards: memoryCards));
  }

  Future<void> _selectCard(SelectCard$MemoryMatchEvent event, Emitter<MemoryMatchState> emit) async {
    if (state.selectedCardIndex == -1) {
      state.memoryCards[event.cardIndex] = state.memoryCards[event.cardIndex].copyWith(isSelected: true);
      emit(state.copyWith(selectedCardIndex: event.cardIndex));
    } else {
      if (state.memoryCards[state.selectedCardIndex].id == state.memoryCards[event.cardIndex].id) {
        state.memoryCards[event.cardIndex] = state.memoryCards[event.cardIndex].copyWith(isSelected: true);
      } else {
        state.memoryCards[event.cardIndex] = state.memoryCards[event.cardIndex].copyWith(isSelected: true);
        emit(state.copyWith(blockButton: true));
        await Future.delayed(Duration(seconds: 1), () {
          state.memoryCards[event.cardIndex] = state.memoryCards[event.cardIndex].copyWith(isSelected: false);
          state.memoryCards[state.selectedCardIndex] = state.memoryCards[state.selectedCardIndex].copyWith(isSelected: false);
          emit(state.copyWith(blockButton: false));
        });
      }
      emit(state.copyWith(selectedCardIndex: -1));
    }

    final win = state.memoryCards.every((card) => card.isSelected);
    emit(state.copyWith(isWin: win));
  }

  void _resetGame(ResetGame$MemoryMatchEvent event, Emitter<MemoryMatchState> emit) {
    _memoryCards.shuffle();

    List<MemoryCard> memoryCards = _memoryCards.sublist(0, 8);
    memoryCards = [...memoryCards, ...memoryCards]..shuffle();

    emit(state.copyWith(selectedCardIndex: -1, blockButton: false, memoryCards: memoryCards, isWin: false));
  }

  // Memory card data

  final List<MemoryCard> _memoryCards = <MemoryCard>[
    MemoryCard(id: 1, imagePath: AppImages.memoryCardAlien),
    MemoryCard(id: 2, imagePath: AppImages.memoryCardAsteroid),
    MemoryCard(id: 3, imagePath: AppImages.memoryCardAstronaut),
    MemoryCard(id: 4, imagePath: AppImages.memoryCardComet),
    MemoryCard(id: 5, imagePath: AppImages.memoryCardConstellation),
    MemoryCard(id: 6, imagePath: AppImages.memoryCardEarth),
    MemoryCard(id: 7, imagePath: AppImages.memoryCardJupiter),
    MemoryCard(id: 8, imagePath: AppImages.memoryCardMars),
    MemoryCard(id: 9, imagePath: AppImages.memoryCardMercury),
    MemoryCard(id: 10, imagePath: AppImages.memoryCardMeteor),
    MemoryCard(id: 11, imagePath: AppImages.memoryCardMoon),
    MemoryCard(id: 12, imagePath: AppImages.memoryCardNeptune),
    MemoryCard(id: 13, imagePath: AppImages.memoryCardObservatory),
    MemoryCard(id: 14, imagePath: AppImages.memoryCardPluto),
    MemoryCard(id: 15, imagePath: AppImages.memoryCardRocket),
    MemoryCard(id: 16, imagePath: AppImages.memoryCardSatellite),
    MemoryCard(id: 17, imagePath: AppImages.memoryCardSaturn),
    MemoryCard(id: 18, imagePath: AppImages.memoryCardSpaceHelmet),
    MemoryCard(id: 19, imagePath: AppImages.memoryCardSpaceShuttle),
    MemoryCard(id: 20, imagePath: AppImages.memoryCardSpaceStation),
    MemoryCard(id: 21, imagePath: AppImages.memoryCardSpaceSuit),
    MemoryCard(id: 22, imagePath: AppImages.memoryCardSpace),
    MemoryCard(id: 23, imagePath: AppImages.memoryCardStar),
    MemoryCard(id: 24, imagePath: AppImages.memoryCardSun),
    MemoryCard(id: 25, imagePath: AppImages.memoryCardTelescope),
    MemoryCard(id: 26, imagePath: AppImages.memoryCardUFO),
    MemoryCard(id: 27, imagePath: AppImages.memoryCardUranus),
    MemoryCard(id: 28, imagePath: AppImages.memoryCardVenus),
  ];
}
