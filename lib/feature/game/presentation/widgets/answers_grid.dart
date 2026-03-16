import 'package:flutter/material.dart';

import 'package:grid_wars/feature/game/domain/entities/answer.dart';
import 'package:grid_wars/feature/game/presentation/widgets/answer_button.dart';

class AnswersGrid extends StatelessWidget {
  const AnswersGrid({super.key, required this.answers, required this.onTap, required this.isGameOver});

  final List<Answer> answers;
  final Function(int answerindex) onTap;
  final bool isGameOver;

  Color _getColor(Answer answer) {
    if (answer.isSelected && !answer.isCorrect) {
      return Colors.red;
    }

    if (answer.isCorrect && isGameOver) {
      return Colors.green;
    }

    return const Color(0xFF203A43);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AnswerButton(
              onTap: () => onTap(0),
              answerText: answers[0].answerText,
              color: _getColor(answers[0]),
              isGameOver: isGameOver,
            ),
            AnswerButton(
              onTap: () => onTap(1),
              answerText: answers[1].answerText,
              color: _getColor(answers[1]),
              isGameOver: isGameOver,
            ),
          ],
        ),
        Row(
          children: [
            AnswerButton(
              onTap: () => onTap(2),
              answerText: answers[2].answerText,
              color: _getColor(answers[2]),
              isGameOver: isGameOver,
            ),
            AnswerButton(
              onTap: () => onTap(3),
              answerText: answers[3].answerText,
              color: _getColor(answers[3]),
              isGameOver: isGameOver,
            ),
          ],
        ),
      ],
    );
  }
}
