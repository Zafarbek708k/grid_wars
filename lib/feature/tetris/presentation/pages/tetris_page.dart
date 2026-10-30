import 'package:easy_localization/easy_localization.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/tetris/game/tetris_game.dart';
import 'package:grid_wars/feature/tetris/presentation/blocs/tetris_cubit/tetris_cubit.dart';

class TetrisPage extends StatefulWidget {
  const TetrisPage({super.key});

  @override
  State<TetrisPage> createState() => _TetrisPageState();
}

class _TetrisPageState extends State<TetrisPage> {
  late final TetrisGame _game;

  @override
  void initState() {
    super.initState();
    _game = TetrisGame(cubit: context.read<TetrisCubit>());
  }

  void _playAgain() {
    context.read<TetrisCubit>().reset();
    _game.restart();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.tetris);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Tetris',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.of(context).pop(), color: accent),
        actions: [
          BlocBuilder<TetrisCubit, TetrisState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ClayIconButton(
                icon: state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: accent,
                onTap: state.isGameOver
                    ? () {}
                    : () {
                        final cubit = context.read<TetrisCubit>();
                        state.isPaused ? cubit.resume() : cubit.pause();
                      },
              ),
            ),
          ),
        ],
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
          child: BlocConsumer<TetrisCubit, TetrisState>(
            listenWhen: (previous, current) => !previous.isGameOver && current.isGameOver,
            listener: (context, state) {
              final cubit = context.read<TetrisCubit>();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(value: cubit, child: _ResultDialog(score: state.score, onPlayAgain: _playAgain)),
              );
            },
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(label: 'SCORE', value: '${state.score}'),
                      const SizedBox(width: 10),
                      _StatChip(label: 'LEVEL', value: '${state.level}'),
                      const SizedBox(width: 10),
                      _StatChip(label: 'LINES', value: '${state.lines}'),
                      const SizedBox(width: 10),
                      _StatChip(label: 'NEXT', value: state.next),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: AspectRatio(
                          aspectRatio: 0.5,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B1620),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(child: GameWidget(game: _game)),
                                if (state.isPaused)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'PAUSED',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClayIconButton(icon: Icons.arrow_back_rounded, color: accent, size: 50, onTap: _game.moveLeft),
                        ClayIconButton(icon: Icons.rotate_right_rounded, color: accent, size: 50, onTap: _game.rotate),
                        ClayIconButton(icon: Icons.arrow_forward_rounded, color: accent, size: 50, onTap: _game.moveRight),
                        ClayIconButton(icon: Icons.arrow_downward_rounded, color: accent, size: 50, onTap: _game.softDrop),
                        ClayIconButton(
                          icon: Icons.keyboard_double_arrow_down_rounded,
                          color: AppColors.grey,
                          size: 50,
                          onTap: _game.hardDrop,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClayResetButton(onTap: _playAgain, label: LocaleKeys.resetGame.tr(), color: accent),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final int score;
  final VoidCallback onPlayAgain;

  const _ResultDialog({required this.score, required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 200,
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
              const Text('GAME OVER', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('SCORE: $score', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClayButton(
                    compact: true,
                    icon: Icons.replay_rounded,
                    color: gameAccentColor(HomeScreenApps.tetris),
                    label: LocaleKeys.playAgain.tr(),
                    onTap: () {
                      Navigator.of(context).pop();
                      onPlayAgain();
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
