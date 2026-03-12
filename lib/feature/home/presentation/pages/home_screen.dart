import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/router/app_router.dart';
import 'package:grid_wars/feature/home/presentation/widgets/inactive_game_card.dart';
import 'package:grid_wars/feature/home/presentation/widgets/play_card.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/app_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: LocaleKeys.homeScreen.tr(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(LocaleKeys.playNow.tr(), style: context.textTheme.bodyMedium),
            ),
            const SizedBox(height: 12),
            PlayCard(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.xAndO);
              },
              item: HomeScreenApps.ticTacToe,
            ),
            PlayCard(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.memoryMatch);
              },
              item: HomeScreenApps.memoryMatch,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(LocaleKeys.comingSoon.tr(), style: context.textTheme.bodyMedium),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: HomeScreenApps.values.where((e) => !e.isActive).length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = HomeScreenApps.values.where((e) => !e.isActive).toList()[index];
                return InActiveGameCard(item: item);
              },
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
