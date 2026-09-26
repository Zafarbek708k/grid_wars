import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/daily_challenge/presentation/blocs/daily_challenge_cubit.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/app_screen.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyChallengeCubit(),
      child: AppScreen(
        title: LocaleKeys.gameScreen.tr(),
        body: BlocBuilder<DailyChallengeCubit, DailyChallengeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d').format(DateTime.now()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 20),
                  _FeaturedGameCard(state: state),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _StatCard(icon: Icons.local_fire_department, color: Colors.orangeAccent, label: 'STREAK', value: '${state.currentStreak}')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(icon: Icons.emoji_events, color: Colors.amberAccent, label: 'BEST', value: '${state.longestStreak}')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(icon: Icons.check_circle, color: Colors.greenAccent, label: 'TOTAL', value: '${state.totalCompleted}')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('LAST 7 DAYS', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1.0)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: state.lastSevenDays
                        .map(
                          (done) => Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done ? Colors.orangeAccent : Colors.white.withValues(alpha: 0.08),
                              border: Border.all(color: done ? Colors.orangeAccent : Colors.white24, width: 1.5),
                            ),
                            child: done ? const Icon(Icons.local_fire_department, color: Colors.white, size: 16) : null,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedGameCard extends StatelessWidget {
  final DailyChallengeState state;

  const _FeaturedGameCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: state.isCompletedToday ? Colors.greenAccent : Colors.cyanAccent, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.6)),
            ),
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(game.icon, colorFilter: const ColorFilter.mode(Colors.cyanAccent, BlendMode.srcIn)),
          ),
          const SizedBox(height: 14),
          Text(
            game.title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            game.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 18),
          if (state.isCompletedToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.greenAccent),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                  SizedBox(width: 8),
                  Text('COMPLETED TODAY', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ],
              ),
            )
          else
            AnimatedButton(
              onTap: () async {
                await Navigator.of(context, rootNavigator: true).pushNamed(game.route);
                if (context.mounted) context.read<DailyChallengeCubit>().refresh();
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)]),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.black),
                    SizedBox(width: 6),
                    Text('PLAY', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.0)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatCard({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
        ],
      ),
    );
  }
}
