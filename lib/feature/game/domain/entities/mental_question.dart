import 'package:flutter/foundation.dart';

import 'package:grid_wars/feature/game/domain/entities/answer.dart';

class MentalQuestion {
  const MentalQuestion({required this.questionText, required this.answers});

  final String questionText;
  final List<Answer> answers;

  @override
  int get hashCode => Object.hashAll([questionText, ...answers]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MentalQuestion &&
            other.runtimeType == runtimeType &&
            other.questionText == questionText &&
            listEquals(other.answers, answers);
  }

  @override
  String toString() {
    return 'MentalQuestion{question_text: $questionText, answers: $answers}';
  }
}
