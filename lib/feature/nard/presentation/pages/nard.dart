import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
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
        leading: AnimatedButton(
          child: Icon(Icons.arrow_back_ios, color: context.themeExtension.whiteToCyan),
          onTap: () => Navigator.of(context).pop(),
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
                            label: 'PLAYER 2',
                            score: state.player2Score,
                            isActive: state.currentPlayer == 2,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
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
                    onTap: () => context.read<NardBloc>().add(const RollDice$NardEvent()),
                    child: Container(
                      width: 220,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)]),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF00E5FF).withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'ROLL DICE',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.2),
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
      floatingActionButton: GestureDetector(
        onTap: () => context.read<NardBloc>().add(const ResetGame$NardEvent()),
        child: Container(
          height: 48,
          margin: EdgeInsetsGeometry.fromLTRB(16, 0, 16, context.padding.bottom + 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors: [Colors.cyanAccent.withValues(alpha: 0.5), Colors.blueAccent.withValues(alpha: 0.5)]),
            boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.3), offset: const Offset(3, 3), blurRadius: 6)],
            border: Border.all(color: AppColors.white.withValues(alpha: 0.4), width: 1.2),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, color: AppColors.white),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.resetGame.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
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
