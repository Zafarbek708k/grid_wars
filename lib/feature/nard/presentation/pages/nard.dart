import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/nard/presentation/blocs/nard_bloc/nard_bloc.dart';

class Nard extends StatelessWidget {
  const Nard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Nard',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
          color: gameAccentColor(HomeScreenApps.nard),
        ),
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
          child: BlocBuilder<NardBloc, NardState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: GameMode.values.map((mode) {
                      final bool isSelected = state.mode == mode;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedButton(
                          onTap: () => context.read<NardBloc>().add(SelectMode$NardEvent(mode: mode)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.cyanAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? Colors.cyanAccent : Colors.white24, width: 1.5),
                            ),
                            child: Text(
                              mode == GameMode.friend ? 'PLAY WITH FRIEND' : 'PLAY VS BOT',
                              style: TextStyle(
                                color: isSelected ? Colors.cyanAccent : Colors.white70,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _PlayerScoreCard(
                            label: 'PLAYER 1',
                            score: state.player1Score,
                            isActive: state.currentPlayer == 1,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _PlayerScoreCard(
                            label: state.mode == GameMode.bot ? 'BOT' : 'PLAYER 2',
                            score: state.player2Score,
                            isActive: state.currentPlayer == 2,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _DiceFace(value: state.dice1),
                      const SizedBox(width: 20),
                      _DiceFace(value: state.dice2),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state.hasRolled)
                    Text(
                      '+${state.lastRollTotal}',
                      style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  const SizedBox(height: 40),
                  AnimatedButton(
                    isDisabled: state.isBotTurn,
                    onTap: () => context.read<NardBloc>().add(const RollDice$NardEvent()),
                    child: Container(
                      width: 220,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: state.isBotTurn
                              ? [Colors.white24, Colors.white12]
                              : const [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                        ),
                        boxShadow: state.isBotTurn
                            ? null
                            : [
                                BoxShadow(color: const Color(0xFF00E5FF).withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 6)),
                              ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        state.isBotTurn ? 'BOT IS ROLLING...' : 'ROLL DICE',
                        style: TextStyle(
                          color: state.isBotTurn ? Colors.white70 : Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: state.isBotTurn ? 15 : 18,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClayResetButton(
        onTap: () => context.read<NardBloc>().add(const ResetGame$NardEvent()),
        label: LocaleKeys.resetGame.tr(),
        color: gameAccentColor(HomeScreenApps.nard),
      ),
    );
  }
}

class _PlayerScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final bool isActive;
  final Color color;

  const _PlayerScoreCard({required this.label, required this.score, required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? color : Colors.white24, width: isActive ? 2.5 : 1.0),
        boxShadow: isActive ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 14, spreadRadius: 1)] : null,
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: isActive ? color : Colors.white54, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text(
            '$score',
            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _DiceFace extends StatelessWidget {
  final int value;

  const _DiceFace({required this.value});

  static const List<List<Alignment>> _pipLayouts = [
    [],
    [Alignment.center],
    [Alignment.topLeft, Alignment.bottomRight],
    [Alignment.topLeft, Alignment.center, Alignment.bottomRight],
    [Alignment.topLeft, Alignment.topRight, Alignment.bottomLeft, Alignment.bottomRight],
    [Alignment.topLeft, Alignment.topRight, Alignment.center, Alignment.bottomLeft, Alignment.bottomRight],
    [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final pips = _pipLayouts[value.clamp(1, 6)];
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Stack(
        children: pips
            .map(
              (alignment) => Align(
                alignment: alignment,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(color: Color(0xFF0F2027), shape: BoxShape.circle),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
