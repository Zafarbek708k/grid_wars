import 'package:flutter/material.dart';

import 'package:grid_wars/core/extensions/context_extension.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.onTap,
    required this.answerText,
    required this.isGameOver,
    this.color = const Color(0xFF203A43),
  });

  final void Function() onTap;
  final String answerText;
  final Color? color;
  final bool isGameOver;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: !isGameOver ? onTap : null,
          child: SizedBox(
            height: 60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                border: BoxBorder.all(color: context.themeExtension.whiteToCyan, width: 3),
              ),
              child: Center(child: Text(answerText, style: context.textTheme.displayMedium)),
            ),
          ),
        ),
      ),
    );
  }
}
