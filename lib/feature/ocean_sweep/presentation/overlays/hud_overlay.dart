import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_session_cubit/ocean_session_cubit.dart';

/// Score/level/shield readout shown while a run is in progress, plus the
/// pause button. Everything but the pause button is non-interactive, so
/// drag gestures still reach the diver underneath.
class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.state, required this.onPause});

  final OceanSessionState state;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Pill(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.recycling, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text('${state.score}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(width: 10),
                  Text('Lv.${state.level}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (state.hasShield)
              _Pill(
                color: const Color(0xFF26C6DA),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('${state.shieldSecondsLeft}s', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                  ],
                ),
              ),
            const Spacer(),
            ClayIconButton(icon: Icons.pause, onTap: onPause, color: gameAccentColor(HomeScreenApps.oceanSweep)),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: (color ?? Colors.black).withValues(alpha: 0.45), borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }
}
