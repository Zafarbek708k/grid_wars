import 'package:flutter/material.dart';

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseModal(
      title: 'GAME PAUSED',
      icon: Icons.pause_circle_outline,
      accentColor: Colors.cyanAccent,
      actions: [
        _ModalButton(
          label: 'RESUME',
          icon: Icons.play_arrow_rounded,
          color: Colors.cyanAccent,
          onTap: onResume,
        ),
        _ModalButton(
          label: 'RESTART',
          icon: Icons.replay_rounded,
          color: Colors.amberAccent,
          onTap: onRestart,
        ),
        _ModalButton(
          label: 'QUIT',
          icon: Icons.exit_to_app_rounded,
          color: Colors.redAccent,
          onTap: onExit,
        ),
      ],
    );
  }
}

class GameOverOverlay extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseModal(
      title: 'GAME OVER',
      subtitle: 'FINAL SCORE: $score',
      icon: Icons.sentiment_very_dissatisfied_rounded,
      accentColor: Colors.redAccent,
      actions: [
        _ModalButton(
          label: 'TRY AGAIN',
          icon: Icons.replay_rounded,
          color: Colors.greenAccent,
          onTap: onRestart,
        ),
        _ModalButton(
          label: 'EXIT TO MENU',
          icon: Icons.home_rounded,
          color: Colors.white70,
          onTap: onExit,
        ),
      ],
    );
  }
}

class LevelCompleteOverlay extends StatelessWidget {
  final int score;
  final int timeRemaining;
  final bool isLastLevel;
  final VoidCallback onNextLevel;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const LevelCompleteOverlay({
    super.key,
    required this.score,
    required this.timeRemaining,
    this.isLastLevel = false,
    required this.onNextLevel,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseModal(
      title: isLastLevel ? 'ALL LEVELS CLEAR!' : 'LEVEL CLEAR!',
      subtitle: 'SCORE: $score  •  TIME BONUS: +${timeRemaining * 10}',
      icon: Icons.emoji_events_rounded,
      accentColor: Colors.amberAccent,
      actions: [
        if (!isLastLevel)
          _ModalButton(
            label: 'NEXT LEVEL',
            icon: Icons.arrow_forward_rounded,
            color: Colors.amberAccent,
            onTap: onNextLevel,
          ),
        _ModalButton(
          label: 'REPLAY',
          icon: Icons.replay_rounded,
          color: Colors.cyanAccent,
          onTap: onRestart,
        ),
        _ModalButton(
          label: 'EXIT',
          icon: Icons.home_rounded,
          color: Colors.white70,
          onTap: onExit,
        ),
      ],
    );
  }
}

class _BaseModal extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final List<Widget> actions;

  const _BaseModal({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1E2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.4),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54, color: accentColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: accentColor,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModalButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
