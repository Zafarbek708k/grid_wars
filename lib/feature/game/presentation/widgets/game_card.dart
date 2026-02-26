import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/game/presentation/widgets/animated_button.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.nameOfGame,
    required this.imageUrl,
    required this.rating,
    required this.numberOfRatedUsers,
    required this.play,
  });

  final String nameOfGame;
  final String imageUrl;
  final int rating;
  final int numberOfRatedUsers;
  final VoidCallback play;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF142638), Color(0xFF0F1E2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: context.themeExtension.whiteToCyan.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 20, offset: const Offset(0, 12)),
          BoxShadow(color: Colors.cyan.withValues(alpha: 0.35), blurRadius: 25, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageUrl.endsWith(".svg")) ...{
            SvgPicture.asset(imageUrl, height: 130, width: double.infinity, fit: BoxFit.cover),
          } else ...{
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.network(imageUrl, height: 130, width: double.infinity, fit: BoxFit.cover),
            ),
          },

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              nameOfGame,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(rating.toString(), style: context.textTheme.bodyMedium),
              const SizedBox(width: 6),
              Text("($numberOfRatedUsers)", style: context.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedButton(
              onTap: play,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(colors: [Colors.cyan, Color(0xFF00BCD4)]),
                  boxShadow: [
                    BoxShadow(color: Colors.cyan.withValues(alpha: 0.6), blurRadius: 15, offset: const Offset(0, 6)),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "PLAY",
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
