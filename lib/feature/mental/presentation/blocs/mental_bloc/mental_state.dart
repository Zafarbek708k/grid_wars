part of 'mental_bloc.dart';

class MentalState extends Equatable {
  const MentalState({
    this.correctAnswerCount = 0,
    this.timer = 10,
    this.questions = const [],
    this.currentQuestionIndex = -1,
    this.isGameOver = false,
    this.rangeMaxNumber = 10,
    this.isResult = false,
  });

  final int correctAnswerCount;
  final int timer;
  final List<MentalQuestion> questions;
  final int currentQuestionIndex;
  final bool isGameOver;
  final int rangeMaxNumber;
  final bool isResult;

  MentalState copyWith({
    int? correctAnswerCount,
    int? timer,
    List<MentalQuestion>? questions,
    int? currentQuestionIndex,
    bool? isGameOver,
    int? rangeMaxNumber,
    bool? isResult,
  }) {
    return MentalState(
      correctAnswerCount: correctAnswerCount ?? this.correctAnswerCount,
      timer: timer ?? this.timer,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isGameOver: isGameOver ?? this.isGameOver,
      rangeMaxNumber: rangeMaxNumber ?? this.rangeMaxNumber,
      isResult: isResult ?? this.isResult,
    );
  }

  @override
  List<Object?> get props => [
    correctAnswerCount,
    timer,
    ...questions,
    currentQuestionIndex,
    isGameOver,
    rangeMaxNumber,
    isResult,
  ];
}
