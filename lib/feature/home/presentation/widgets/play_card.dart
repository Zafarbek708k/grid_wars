import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/home/presentation/widgets/rating_stars.dart';

class PlayCard extends StatelessWidget {
  const PlayCard({super.key, required this.onTap, required this.item});

  final Function() onTap;

  final HomeScreenApps item;

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(item);

    return AnimatedButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [accent.withValues(alpha: 0.9), accent.withValues(alpha: 0.55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.4),
          boxShadow: [
            // Depth shadow, as if the tile is puffed out of the background.
            BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 18, offset: const Offset(6, 10)),
            // Soft opposite-corner glow to fake a light source hitting the clay.
            BoxShadow(color: Colors.white.withValues(alpha: 0.18), blurRadius: 14, offset: const Offset(-4, -4)),
            BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 22, spreadRadius: 1),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // A top sheen to sell the "puffy clay" volume.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 46,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    item.icon,
                    height: 42,
                    width: 42,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RatingStars(rating: item.rating),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
