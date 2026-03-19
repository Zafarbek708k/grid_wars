import 'package:flutter/material.dart';

class MathText extends StatelessWidget {
  final String question;
  final String highlight;
  final Color color;

  const MathText({super.key, required this.question, required this.highlight, required this.color});

  @override
  Widget build(BuildContext context) {
    final numbers = question.split(' ');

    TextStyle highlightStyle(String number) =>
        TextStyle(color: number == highlight ? color : null);

    return Text.rich(
      TextSpan(
        style: const TextStyle(color: Colors.white),
        children: [
          TextSpan(text: numbers[0], style: highlightStyle(numbers[0])),
          TextSpan(text: " ${numbers[1]} "),
          TextSpan(text: numbers[2], style: highlightStyle(numbers[2])),
          const TextSpan(text: " = "),
          TextSpan(text: numbers[4], style: highlightStyle(numbers[4])),
        ],
      ),
    );
  }
}