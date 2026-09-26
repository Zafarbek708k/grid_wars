import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/coin_model.dart';

class CoinWidget extends StatelessWidget {
  final CoinModel coin;

  const CoinWidget({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: coin.width,
      height: coin.height,
      decoration: BoxDecoration(
        color: GameConfig.coinColor,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB8860B), width: 2.0),
        boxShadow: [
          BoxShadow(color: GameConfig.coinColor.withValues(alpha: 0.6), blurRadius: 8, spreadRadius: 1),
        ],
      ),
      child: const Center(
        child: Text(
          '¢',
          style: TextStyle(color: Color(0xFFB8860B), fontWeight: FontWeight.w900, fontSize: 13),
        ),
      ),
    );
  }
}
