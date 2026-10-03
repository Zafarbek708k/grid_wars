import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_stats_cubit/ocean_stats_cubit.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({
    super.key,
    required this.score,
    required this.onPlayAgain,
    required this.onExit,
    required this.onShowLeaderboard,
  });

  final int score;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;
  final VoidCallback onShowLeaderboard;

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.oceanSweep);

    return Container(
      color: Colors.black.withValues(alpha: 0.65),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.waves, color: Colors.white, size: 48),
            const SizedBox(height: 10),
            const Text('GAME OVER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            Text('${LocaleKeys.score.tr()}: $score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            BlocBuilder<OceanStatsCubit, OceanStatsState>(
              builder: (context, state) {
                if (!state.lastIsNewHighScore) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: const Text('NEW HIGH SCORE!', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: ClayButton(expand: true, icon: Icons.refresh, label: LocaleKeys.playAgain.tr(), color: accent, onTap: onPlayAgain),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 220,
              child: ClayButton(expand: true, icon: Icons.home, label: LocaleKeys.backToHome.tr(), color: Colors.grey, onTap: onExit),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: onShowLeaderboard,
              child: const Text('Leaderboard', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
