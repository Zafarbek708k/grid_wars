part of 'mental_bloc.dart';

sealed class MentalEvent {
  const MentalEvent();
}

final class InitialData$MentalEvent extends MentalEvent {
  const InitialData$MentalEvent();
}

final class SelectAnswer$MentalEvent extends MentalEvent {
  const SelectAnswer$MentalEvent({required this.answerIndex});

  final int answerIndex;
}

final class GameOver$MentalEvent extends MentalEvent {
  const GameOver$MentalEvent();
}

final class StartTimer$MentalEvent extends MentalEvent {
  const StartTimer$MentalEvent();
}

final class UpdateQuestions$MentalEvent extends MentalEvent {
  const UpdateQuestions$MentalEvent();
}

final class RestartGame$MentalEvent extends MentalEvent {
  const RestartGame$MentalEvent();
}
