import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/game/domain/entities/answer.dart';
import 'package:grid_wars/feature/game/domain/entities/mental_question.dart';

part 'mental_event.dart';
part 'mental_state.dart';

class MentalBloc extends Bloc<MentalEvent, MentalState> {
  MentalBloc() : super(MentalState()) {
    on<MentalEvent>(
      (event, emit) => switch (event) {
        InitialData$MentalEvent _ => _initialData(event, emit),
        StartTimer$MentalEvent _ => _startTimer(event, emit),
        SelectAnswer$MentalEvent _ => _selectAnswer(event, emit),
        UpdateQuestions$MentalEvent _ => _updateQuestions(event, emit),
        GameOver$MentalEvent _ => _gameOver(event, emit),
        RestartGame$MentalEvent _ => _restartGame(event, emit),
      },
    );

    add(const InitialData$MentalEvent());
  }

  Timer? _timer;
  final _random = Random();

  void _initialData(InitialData$MentalEvent event, Emitter<MentalState> emit) {
    List<MentalQuestion> questions = List.generate(10, (_) => _generateMathQuestion());

    emit(state.copyWith(currentQuestionIndex: 0, correctAnswerCount: 0, questions: questions, timer: 10));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer > 0) {
        add(const StartTimer$MentalEvent());
      } else {
        add(const GameOver$MentalEvent());
      }
    });
  }

  void _startTimer(StartTimer$MentalEvent event, Emitter<MentalState> emit) {
    emit(state.copyWith(timer: state.timer - 1));
  }

  void _selectAnswer(SelectAnswer$MentalEvent event, Emitter<MentalState> emit) {
    if (state.questions[state.currentQuestionIndex].answers[event.answerIndex].isCorrect) {
      if ((state.currentQuestionIndex + 1) % 10 == 0) add(const UpdateQuestions$MentalEvent());

      emit(
        state.copyWith(
          correctAnswerCount: state.correctAnswerCount + 1,
          currentQuestionIndex: state.currentQuestionIndex + 1,
          timer: 10,
        ),
      );
    } else {
      Answer answer = state.questions[state.currentQuestionIndex].answers[event.answerIndex];
      state.questions[state.currentQuestionIndex].answers[event.answerIndex] = answer.copyWith(isSelected: true);

      add(const GameOver$MentalEvent());
    }
  }

  void _updateQuestions(UpdateQuestions$MentalEvent event, Emitter<MentalState> emit) {
    List<MentalQuestion> questions = List.generate(
      10,
      (_) => _generateMathQuestion(state.rangeMaxNumber, state.rangeMaxNumber + 10),
    );

    emit(state.copyWith(questions: [...state.questions, ...questions], rangeMaxNumber: state.rangeMaxNumber + 10));
  }

  Future<void> _gameOver(GameOver$MentalEvent event, Emitter<MentalState> emit) async {
    emit(state.copyWith(isGameOver: true));

    _stopTimer();

    await Future.delayed(Duration(seconds: 2));

    emit(state.copyWith(isResult: true));
  }

  void _restartGame(RestartGame$MentalEvent event, Emitter<MentalState> emit) {
    emit(state.copyWith(isGameOver: false, isResult: false));

    add(const InitialData$MentalEvent());
  }

  // Helpers functions

  MentalQuestion _generateMathQuestion([int start = 1, int max = 20]) {
    int numberFirst = _random.nextInt(max) + start;
    int numberSecond = _random.nextInt(max) + start;
    int correct = numberFirst + numberSecond;
    int number = _random.nextInt(3) + 1;

    switch (number) {
      case 1:
        List<int> options = _createOptions(numberFirst, max, start);

        return MentalQuestion(
          questionText: '? + $numberSecond = $correct',
          answers: options.map((element) => Answer(answerText: element.toString(), isCorrect: element == numberFirst)).toList(),
        );
      case 2:
        List<int> options = _createOptions(numberSecond, max, start);

        return MentalQuestion(
          questionText: '$numberFirst + ? = $correct',
          answers: options.map((element) => Answer(answerText: element.toString(), isCorrect: element == numberSecond)).toList(),
        );
      default:
        List<int> options = _createOptions(correct, max, start);

        return MentalQuestion(
          questionText: '$numberFirst + $numberSecond = ?',
          answers: options.map((element) => Answer(answerText: element.toString(), isCorrect: element == correct)).toList(),
        );
    }
  }

  List<int> _createOptions(int correct, int max, int start) {
    List<int> options = {correct}.toList();

    while (options.length < 4) {
      int wrong = correct + _random.nextInt(max) + start;

      if (wrong != correct && !options.contains(wrong) && wrong > 0) {
        options.add(wrong);
      }
    }

    options.shuffle();

    return options;
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }
}
