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
import 'package:grid_wars/feature/snake/domain/entities/direction.dart';
import 'package:grid_wars/feature/snake/game/snake_game.dart';
import 'package:grid_wars/feature/snake/presentation/blocs/snake_cubit/snake_cubit.dart';

class SnakePage extends StatefulWidget {
  const SnakePage({super.key});

  @override
  State<SnakePage> createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  late final SnakeGame _game;
  double _accumDx = 0;
  double _accumDy = 0;

  static const double _swipeThreshold = 14;

  @override
  void initState() {
    super.initState();
    _game = SnakeGame(cubit: context.read<SnakeCubit>());
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _accumDx += details.delta.dx;
    _accumDy += details.delta.dy;
    if (_accumDx.abs() < _swipeThreshold && _accumDy.abs() < _swipeThreshold) return;

    if (_accumDx.abs() > _accumDy.abs()) {
      _game.changeDirection(_accumDx > 0 ? Direction.right : Direction.left);
    } else {
      _game.changeDirection(_accumDy > 0 ? Direction.down : Direction.up);
    }
    _accumDx = 0;
    _accumDy = 0;
  }

  void _playAgain() {
    context.read<SnakeCubit>().reset();
    _game.restart();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.snake);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Snake',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.of(context).pop(), color: accent),
        actions: [
          BlocBuilder<SnakeCubit, SnakeState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ClayIconButton(
                icon: state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: accent,
                onTap: state.isGameOver
                    ? () {}
                    : () {
                        final cubit = context.read<SnakeCubit>();
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
          child: BlocConsumer<SnakeCubit, SnakeState>(
            listenWhen: (previous, current) => !previous.isGameOver && current.isGameOver,
            listener: (context, state) {
              final cubit = context.read<SnakeCubit>();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(value: cubit, child: _SnakeResultDialog(score: state.score, onPlayAgain: _playAgain)),
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
                      const SizedBox(width: 16),
                      _StatChip(label: 'BEST', value: '${state.best}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B1620),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: GestureDetector(onPanUpdate: _handlePanUpdate, child: GameWidget(game: _game)),
                                ),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Swipe to steer', style: TextStyle(color: Colors.white38, fontSize: 12)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _SnakeResultDialog extends StatelessWidget {
  final int score;
  final VoidCallback onPlayAgain;

  const _SnakeResultDialog({required this.score, required this.onPlayAgain});

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
                    color: gameAccentColor(HomeScreenApps.snake),
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
