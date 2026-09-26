import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';

class GameBackground extends StatelessWidget {
  final double cameraX;
  final double worldHeight;

  const GameBackground({
    super.key,
    required this.cameraX,
    required this.worldHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Parallax factor: background elements scroll slower than foreground
    final double parallaxOffset = cameraX * 0.25;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3A7BD5),
            Color(0xFF5C94FC),
            Color(0xFF90C2FF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Distant mountains (Parallax)
          Positioned(
            bottom: GameConfig.groundHeight + 10,
            left: -parallaxOffset % 600 - 100,
            child: Row(
              children: List.generate(
                8,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 140),
                  child: Icon(
                    Icons.landscape_rounded,
                    size: 90,
                    color: const Color(0xFF2C7436).withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          ),

          // Floating clouds (Gentle parallax)
          Positioned(
            top: 25,
            left: -(cameraX * 0.1) % 500,
            child: Row(
              children: List.generate(
                6,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Icon(
                    Icons.cloud_rounded,
                    size: i % 2 == 0 ? 56 : 42,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinishFlagWidget extends StatelessWidget {
  final double width;
  final double height;

  const FinishFlagWidget({
    super.key,
    this.width = 44.0,
    this.height = 160.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Flag Pole
          Container(
            width: 8,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black54, width: 1.5),
            ),
          ),

          // Pole Top Ball
          Positioned(
            top: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.amberAccent, blurRadius: 8, spreadRadius: 2),
                ],
              ),
            ),
          ),

          // Flag Banner
          Positioned(
            top: 14,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(2, 2)),
                ],
              ),
              child: const Icon(
                Icons.sports_score,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
