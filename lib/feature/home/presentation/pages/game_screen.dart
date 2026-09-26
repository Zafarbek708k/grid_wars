import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/router/app_router.dart';
import 'package:grid_wars/feature/home/presentation/widgets/game_card.dart';
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
      title: LocaleKeys.gameScreen.tr(),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20).copyWith(bottom: 120),
        itemCount: HomeScreenApps.values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.76,
        ),
        itemBuilder: (context, index) {
          final item = HomeScreenApps.values[index];
          return GameCard(
            nameOfGame: item.name,
            imageUrl: item.icon,
            rating: item.rating,
            numberOfRatedUsers: item.rating,
            play: () {
              if (item.isMario2D) {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.platformer);
              } else if (item.isTicTacToe) {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.xAndO);
              } else if (item.isMemoryMatch) {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.memoryMatch);
              } else if (item.isMath) {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.mental);
              } else if (item.isFifteenPuzzle) {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.puzzle15);
              } else if (item.isSudoku) {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.sudoku);
              } else if (item.isNard) {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.nard);
              }
            },
          );
        },
      ),
    );
  }
}
