import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/game/presentation/widgets/math_text.dart';

class MentalResultDialog extends StatelessWidget {
  const MentalResultDialog({
    super.key,
    required this.onRestart,
    required this.score,
    required this.userAnswerText,
    required this.correctAnswerText,
    required this.userAnswerHighlightText,
    required this.correctAnswerHighlightText,
  });

  final String userAnswerText;
  final String userAnswerHighlightText;
  final String correctAnswerText;
  final String correctAnswerHighlightText;
  final int score;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocaleKeys.result.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.score.tr()),
                  Text(score.toString()),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.yourAnswer.tr(),
                    style: context.textTheme.headlineSmall?.copyWith(color: AppColors.red),
                  ),
                  MathText(
                    question: userAnswerText,
                    highlight: userAnswerHighlightText,
                    color: AppColors.red,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.correctAnswer.tr(),
                    style: context.textTheme.headlineSmall?.copyWith(color: AppColors.green),
                  ),
                  MathText(
                    question: correctAnswerText,
                    highlight: correctAnswerHighlightText,
                    color: AppColors.green,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedButton(
                    onTap: onRestart,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C5364),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: const Color(0xFF0F2027), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(LocaleKeys.playAgain.tr()),
                      ),
                    ),
                  ),

                  AnimatedButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C5364),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: const Color(0xFF0F2027), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(LocaleKeys.backToHome.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}