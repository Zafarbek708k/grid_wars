import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/hangman/domain/services/hangman_engine.dart';
import 'package:grid_wars/feature/hangman/presentation/blocs/hangman_bloc/hangman_bloc.dart';
import 'package:grid_wars/feature/hangman/presentation/widgets/hangman_figure_painter.dart';

class Hangman extends StatelessWidget {
  const Hangman({super.key});

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.hangman);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Hangman',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.of(context).pop(), color: accent),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<HangmanBloc, HangmanState>(
            listenWhen: (previous, current) => !previous.isGameOver && current.isGameOver,
            listener: (context, state) {
              final bloc = context.read<HangmanBloc>();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(value: bloc, child: _ResultDialog(won: state.isWin, word: state.word)),
              );
            },
            builder: (context, state) {
              if (state.word.isEmpty) return const SizedBox.shrink();

              return Column(
                children: [
                  const SizedBox(height: 8),
                  _HintChip(hint: state.hint),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CustomPaint(painter: HangmanFigurePainter(wrongGuessCount: state.wrongGuessCount, color: accent)),
                  ),
                  Text(
                    '${HangmanEngine.maxWrongGuesses - state.wrongGuessCount} guesses left',
                    style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 8,
                      children: state.maskedWord.split('').map((c) => _LetterTile(letter: c)).toList(),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: _Keyboard(state: state, accent: accent),
                  ),
                  const SizedBox(height: 70),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClayResetButton(
        onTap: () => context.read<HangmanBloc>().add(const NewGame$HangmanEvent()),
        label: LocaleKeys.resetGame.tr(),
        color: accent,
      ),
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(hint.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    final bool revealed = letter != '_';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 28,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: revealed ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
        border: const Border(bottom: BorderSide(color: Colors.white54, width: 2)),
      ),
      child: Text(
        revealed ? letter : '',
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _Keyboard extends StatelessWidget {
  const _Keyboard({required this.state, required this.accent});

  final HangmanState state;
  final Color accent;

  static const String _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: _letters.split('').map((letter) {
        final bool guessed = state.guessedLetters.contains(letter);
        final bool correct = guessed && state.word.contains(letter);
        final Color fill = !guessed
            ? Colors.white.withValues(alpha: 0.08)
            : correct
            ? const Color(0xFF2E7D32)
            : const Color(0xFFB71C1C);

        return SizedBox(
          width: 32,
          height: 40,
          child: Material(
            color: fill,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: (guessed || state.isGameOver)
                  ? null
                  : () => context.read<HangmanBloc>().add(GuessLetter$HangmanEvent(letter: letter)),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: guessed ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog({required this.won, required this.word});

  final bool won;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 210,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                won ? LocaleKeys.youWin.tr() : 'GAME OVER',
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('THE WORD WAS: $word', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClayButton(
                    compact: true,
                    icon: Icons.replay_rounded,
                    color: gameAccentColor(HomeScreenApps.hangman),
                    label: LocaleKeys.playAgain.tr(),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<HangmanBloc>().add(const NewGame$HangmanEvent());
                    },
                  ),
                  ClayButton(
                    compact: true,
                    icon: Icons.home_rounded,
                    color: AppColors.grey,
                    label: LocaleKeys.backToHome.tr(),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
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
