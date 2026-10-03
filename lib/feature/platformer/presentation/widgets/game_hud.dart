import 'package:flutter/material.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';

class GameHud extends StatelessWidget {
  final int score;
  final int coins;
  final String world;
  final int time;
  final int lives;
  final VoidCallback onPause;

  const GameHud({
    super.key,
    required this.score,
    required this.coins,
    required this.world,
    required this.time,
    required this.lives,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: GameConfig.hudBackgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: Colors.white24, width: 1.0),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Stat columns scroll horizontally instead of overflowing on
            // narrow widths (e.g. mid-rotation to landscape).
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PLAYER & SCORE
                    _HudColumn(
                      title: 'HERO',
                      value: score.toString().padLeft(6, '0'),
                      icon: Icons.person_rounded,
                      color: Colors.cyanAccent,
                    ),
                    const SizedBox(width: 18),

                    // COINS
                    _HudColumn(
                      title: 'COINS',
                      value: 'x${coins.toString().padLeft(2, '0')}',
                      icon: Icons.monetization_on_rounded,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 18),

                    // WORLD
                    _HudColumn(
                      title: 'WORLD',
                      value: world,
                      icon: Icons.public_rounded,
                      color: Colors.lightGreenAccent,
                    ),
                    const SizedBox(width: 18),

                    // TIME
                    _HudColumn(
                      title: 'TIME',
                      value: time.toString().padLeft(3, '0'),
                      icon: Icons.timer_outlined,
                      color: time < 50 ? Colors.redAccent : Colors.orangeAccent,
                    ),
                    const SizedBox(width: 18),

                    // LIVES
                    _HudColumn(
                      title: 'LIVES',
                      value: 'x$lives',
                      icon: Icons.favorite,
                      color: Colors.pinkAccent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // PAUSE BUTTON
            ClayIconButton(icon: Icons.pause_rounded, onTap: onPause, color: Colors.blueGrey, size: 34, iconSize: 18),
          ],
        ),
      ),
    );
  }
}

class _HudColumn extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _HudColumn({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
