import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/game/domain/entities/answer.dart';
import 'package:grid_wars/feature/game/domain/entities/mental_question.dart';
import 'package:grid_wars/feature/game/presentation/blocs/mental_bloc/mental_bloc.dart';
import 'package:grid_wars/feature/game/presentation/widgets/answers_grid.dart';
import 'package:grid_wars/feature/game/presentation/widgets/mental_result_dialog.dart';
import 'package:grid_wars/feature/game/presentation/widgets/time_progress_bar.dart';

class Mental extends StatefulWidget {
  const Mental({super.key});

  @override
  State<Mental> createState() => _MentalState();
}

class _MentalState extends State<Mental> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.white.withValues(alpha: 0.1),
          automaticallyImplyLeading: true,
          title: Text(
            'Mental',
            style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
          ),
          leading: AnimatedButton(
            child: Icon(Icons.arrow_back_ios, color: context.themeExtension.whiteToCyan),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: BlocBuilder<MentalBloc, MentalState>(
            buildWhen: (previous, current) {
              bool timer = previous.timer != current.timer;
              bool currentQuestionIndex = previous.currentQuestionIndex != current.currentQuestionIndex;
              bool isGameOver = previous.isGameOver != current.isGameOver;
              bool isResult = previous.isResult != current.isResult;

              return timer || currentQuestionIndex || isGameOver || isResult;
            },
            builder: (context, state) {
              if (state.questions.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              if (state.isResult) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => MentalResultDialog(
                      score: state.correctAnswerCount,
                      userAnswerText: state.questions[state.currentQuestionIndex].questionText.replaceAll(
                        '?',
                        state.questions[state.currentQuestionIndex].answers
                            .firstWhere((e) => e.isSelected, orElse: () => Answer(answerText: '_'))
                            .answerText,
                      ),
                      userAnswerHighlightText: state.questions[state.currentQuestionIndex].answers
                          .firstWhere((e) => e.isSelected, orElse: () => Answer(answerText: '_'))
                          .answerText,
                      correctAnswerText: state.questions[state.currentQuestionIndex].questionText.replaceAll(
                        '?',
                        state.questions[state.currentQuestionIndex].answers.firstWhere((e) => e.isCorrect).answerText,
                      ),
                      correctAnswerHighlightText: state.questions[state.currentQuestionIndex].answers
                          .firstWhere((e) => e.isCorrect)
                          .answerText,
                      onRestart: () {
                        context.read<MentalBloc>().add(const RestartGame$MentalEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                });
              }

              MentalQuestion question = state.questions[state.currentQuestionIndex];

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.timer, color: context.themeExtension.whiteToCyan, size: 30),
                          Text(state.timer.toString()),
                        ],
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          SvgPicture.asset(
                            AppIcons.trophy,
                            height: 30,
                            width: 30,
                            colorFilter: ColorFilter.mode(context.themeExtension.whiteToCyan, BlendMode.srcIn),
                          ),
                          Text(state.correctAnswerCount.toString()),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TimerProgressBar(
                      duration: 10,
                      questionKey: state.questions[state.currentQuestionIndex].questionText,
                      color: context.themeExtension.whiteToCyan,
                      stop: state.isGameOver,
                    ),
                  ),

                  Expanded(
                    child: Center(child: Text(question.questionText, style: context.textTheme.displayLarge)),
                  ),

                  AnswersGrid(
                    answers: question.answers,
                    isGameOver: state.isGameOver,
                    onTap: (answerIndex) {
                      context.read<MentalBloc>().add(SelectAnswer$MentalEvent(answerIndex: answerIndex));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
