import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_stats_cubit/ocean_stats_cubit.dart';

/// Shown before a run starts. Asks for a one-time nickname, then shows the
/// current best score and a Play button.
class MenuOverlay extends StatefulWidget {
  const MenuOverlay({super.key, required this.onPlay, required this.onShowLeaderboard});

  final VoidCallback onPlay;
  final VoidCallback onShowLeaderboard;

  @override
  State<MenuOverlay> createState() => _MenuOverlayState();
}

class _MenuOverlayState extends State<MenuOverlay> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: context.read<OceanStatsCubit>().state.nickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePlay() {
    final OceanStatsCubit statsCubit = context.read<OceanStatsCubit>();
    final String nickname = _controller.text.trim();
    if (nickname.isEmpty) return;
    if (nickname != statsCubit.state.nickname) statsCubit.saveNickname(nickname);
    widget.onPlay();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.oceanSweep);

    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water, color: Color(0xFF29B6F6), size: 64),
            const SizedBox(height: 12),
            const Text(
              'OCEAN SWEEP',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 30, letterSpacing: 2),
            ),
            const SizedBox(height: 6),
            const Text(
              "Drag to swim, collect plastic, dodge the ocean's dangers.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 22),
            BlocBuilder<OceanStatsCubit, OceanStatsState>(
              builder: (context, state) {
                if (!state.needsNickname) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Best score: ${state.highScore}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    maxLength: 12,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter a nickname',
                      hintStyle: const TextStyle(color: Colors.white54),
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              width: 220,
              child: ClayButton(expand: true, icon: Icons.play_arrow_rounded, label: 'PLAY', color: accent, onTap: _handlePlay),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: widget.onShowLeaderboard,
              child: const Text('Leaderboard', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
