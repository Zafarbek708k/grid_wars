import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/domain/entities/player_model.dart';

/// Renders the Mario character using pure Flutter styling, Material Icons,
/// signature red cap with "M" emblem, mustache, and blue overalls.
class PlayerWidget extends StatelessWidget {
  final PlayerModel player;

  const PlayerWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final bool isFacingLeft = player.direction == PlayerDirection.left;
    final bool isAirborne = player.isJumping || !player.isGrounded;

    return Transform(
      alignment: Alignment.center,
      transform: isFacingLeft ? Matrix4.rotationY(math.pi) : Matrix4.identity(),
      child: Container(
        width: player.width,
        height: player.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            if (player.isBig)
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.5),
                blurRadius: 14,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          children: [
            // 1. MARIO'S RED CAP with "M" EMBLEM
            Expanded(
              flex: player.isBig ? 3 : 4,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Cap Dome
                  Container(
                    width: player.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE52521), // Mario signature red
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      border: Border.all(color: const Color(0xFF8B0000), width: 1.5),
                    ),
                  ),

                  // Cap Visor Brim
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: player.width * 0.55,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // White Emblem with Red "M"
                  Positioned(
                    top: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 2),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Color(0xFFE52521),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. MARIO'S FACE & MUSTACHE
            Expanded(
              flex: 4,
              child: Container(
                width: player.width * 0.9,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCC99), // Peach skin tone
                  border: Border.all(color: const Color(0xFFD48C56), width: 1.0),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Eyes
                    Positioned(
                      top: 2,
                      right: 8,
                      child: Container(
                        width: 4,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Big Dark Mustache
                    Positioned(
                      bottom: 1,
                      right: 4,
                      child: Container(
                        width: 18,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E1F00),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black54, width: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. MARIO'S BLUE OVERALLS & RED SHIRT
            Expanded(
              flex: player.isBig ? 6 : 5,
              child: Container(
                width: player.width,
                decoration: BoxDecoration(
                  color: const Color(0xFF0038A8), // Blue denim
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
                  border: Border.all(color: const Color(0xFF001F5C), width: 1.5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Red Shirt sides
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 4, color: const Color(0xFFE52521)),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 4, color: const Color(0xFFE52521)),
                    ),

                    // Two Yellow Overall Buttons
                    Positioned(
                      top: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                          ),
                        ],
                      ),
                    ),

                    // Motion Icon Indicator
                    Center(
                      child: Icon(
                        isAirborne
                            ? Icons.flight_takeoff
                            : (player.isMoving ? Icons.directions_run : Icons.star_border),
                        color: Colors.white70,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. BROWN WORK BOOTS
            Container(
              width: player.width,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF5C2B05), // Brown shoes
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
