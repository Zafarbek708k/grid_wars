import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/feature/game/presentation/widgets/game_card.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/app_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: "Game Screen",
      body: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: GameCard(
                  nameOfGame: "Tic Tac Toe",
                  imageUrl: AppIcons.o,
                  rating: 5,
                  numberOfRatedUsers: 456,
                  play: () {},
                ),
              ),
              Expanded(
                child: GameCard(
                  nameOfGame: "15 Puzzle",
                  imageUrl: AppIcons.game,
                  rating: 5,
                  numberOfRatedUsers: 456,
                  play: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
