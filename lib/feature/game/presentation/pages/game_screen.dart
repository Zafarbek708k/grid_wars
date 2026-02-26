import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
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
            play: () {},
          );
        },
      ),
    );
  }
}
