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
import 'package:grid_wars/feature/bubble_shooter/game/bubble_shooter_game.dart';
import 'package:grid_wars/feature/bubble_shooter/presentation/blocs/bubble_shooter_cubit/bubble_shooter_cubit.dart';

const Map<String, Color> _swatchColors = {
  'red': Color(0xFFEF5350),
  'blue': Color(0xFF42A5F5),
  'green': Color(0xFF66BB6A),
  'yellow': Color(0xFFFDD835),
  'purple': Color(0xFFAB47BC),
};

class BubbleShooterPage extends StatefulWidget {
  const BubbleShooterPage({super.key});

  @override
  State<BubbleShooterPage> createState() => _BubbleShooterPageState();
}

class _BubbleShooterPageState extends State<BubbleShooterPage> {
  late final BubbleShooterGame _game;

  @override
  void initState() {
    super.initState();
    _game = BubbleShooterGame(cubit: context.read<BubbleShooterCubit>());
  }

  void _playAgain() {
    context.read<BubbleShooterCubit>().reset();
    _game.restart();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.bubbleShooter);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Bubble Shooter',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.of(context).pop(), color: accent),
        actions: [
          BlocBuilder<BubbleShooterCubit, BubbleShooterState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ClayIconButton(
                icon: state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: accent,
                onTap: state.isGameOver
                    ? () {}
                    : () {
                        final cubit = context.read<BubbleShooterCubit>();
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
          child: BlocConsumer<BubbleShooterCubit, BubbleShooterState>(
            listenWhen: (previous, current) => !previous.isGameOver && current.isGameOver,
            listener: (context, state) {
              final cubit = context.read<BubbleShooterCubit>();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: _ResultDialog(won: state.isWin, score: state.score, onPlayAgain: _playAgain),
                ),
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
                      _StatChip(label: 'BEST', value: '${state.best}'),
                      const SizedBox(width: 10),
                      _SwatchChip(label: 'NEXT', colorName: state.next),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 0.58,
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
                                  child: GestureDetector(
                                    onPanStart: (d) => _game.updateAim(Vector2(d.localPosition.dx, d.localPosition.dy)),
                                    onPanUpdate: (d) => _game.updateAim(Vector2(d.localPosition.dx, d.localPosition.dy)),
                                    onPanEnd: (_) => _game.fire(),
                                    child: GameWidget(game: _game),
                                  ),
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
                    child: Text('Drag to aim, release to shoot', style: TextStyle(color: Colors.white38, fontSize: 12)),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

class _SwatchChip extends StatelessWidget {
  final String label;
  final String colorName;

  const _SwatchChip({required this.label, required this.colorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
          const SizedBox(height: 2),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _swatchColors[colorName] ?? Colors.white24),
          ),
        ],
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final bool won;
  final int score;
  final VoidCallback onPlayAgain;

  const _ResultDialog({required this.won, required this.score, required this.onPlayAgain});

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
              Text(
                won ? LocaleKeys.youWin.tr() : 'GAME OVER',
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('SCORE: $score', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClayButton(
                    compact: true,
                    icon: Icons.replay_rounded,
                    color: gameAccentColor(HomeScreenApps.bubbleShooter),
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
