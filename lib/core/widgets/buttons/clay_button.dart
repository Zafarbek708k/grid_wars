import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';

/// A claymorphic action button — puffy, colorful, dual-shadow depth —
/// matching the style used for the Home screen's game tiles. Used for both
/// full-width reset buttons ([expand]) and compact dialog actions
/// ([compact]).
class ClayButton extends StatelessWidget {
  const ClayButton({
    super.key,
    required this.onTap,
    required this.label,
    this.icon,
    this.color = AppColors.cyan,
    this.expand = false,
    this.compact = false,
  });

  final VoidCallback onTap;
  final String label;
  final IconData? icon;
  final Color color;
  final bool expand;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double fontSize = compact ? 13 : 15;
    final double iconSize = compact ? 18 : 20;
    final double radius = compact ? 14 : 16;

    return AnimatedButton(
      onTap: onTap,
      child: Container(
        width: expand ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 20, vertical: compact ? 12 : 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.58)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: compact ? 10 : 14,
              offset: Offset(compact ? 3 : 4, compact ? 5 : 6),
            ),
            BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: compact ? 8 : 10, offset: const Offset(-3, -3)),
          ],
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: iconSize),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: fontSize, letterSpacing: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A circular claymorphic icon-only button — same puffy depth as
/// [ClayButton] — for back/pause/close actions where a label doesn't fit
/// (e.g. an AppBar's leading slot).
class ClayIconButton extends StatelessWidget {
  const ClayIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.cyan,
    this.size = 38,
    this.iconSize = 18,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.58)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(3, 4)),
            BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(-2, -2)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }
}

/// The center-docked "reset game" FAB every simple game page uses, styled
/// with that game's [color] and positioned with the standard bottom-safe-area
/// margin.
class ClayResetButton extends StatelessWidget {
  const ClayResetButton({super.key, required this.onTap, required this.label, this.color = AppColors.cyan});

  final VoidCallback onTap;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsets.fromLTRB(16, 0, 16, context.padding.bottom + 12),
      child: ClayButton(onTap: onTap, label: label, icon: Icons.refresh, color: color, expand: true),
    );
  }
}
