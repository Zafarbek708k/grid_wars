import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/power_up_model.dart';

class PowerUpWidget extends StatelessWidget {
  final PowerUpModel powerUp;

  const PowerUpWidget({super.key, required this.powerUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: powerUp.width,
      height: powerUp.height,
      decoration: BoxDecoration(
        color: GameConfig.mushroomColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.0),
        boxShadow: [
          BoxShadow(color: GameConfig.mushroomColor.withValues(alpha: 0.6), blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned(
            top: 4,
            child: Icon(Icons.circle, color: Colors.white, size: 8),
          ),
        ],
      ),
    );
  }
}
