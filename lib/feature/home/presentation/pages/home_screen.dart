import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/router/app_router.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/home/presentation/widgets/inactive_game_card.dart';
import 'package:grid_wars/feature/home/presentation/widgets/play_card.dart';
import 'package:grid_wars/feature/navigation/presentation/blocs/navigator_cubit.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/app_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final List<(HomeScreenApps item, String route)> _activeGames = [
    (HomeScreenApps.mario2D, AppRouter.platformer),
    (HomeScreenApps.ticTacToe, AppRouter.xAndO),
    (HomeScreenApps.game2048, AppRouter.game2048),
    (HomeScreenApps.math, AppRouter.mental),
    (HomeScreenApps.fifteenPuzzle, AppRouter.puzzle15),
    (HomeScreenApps.sudoku, AppRouter.sudoku),
    (HomeScreenApps.nard, AppRouter.nard),
    (HomeScreenApps.wordSearch, AppRouter.wordSearch),
    (HomeScreenApps.minesweeper, AppRouter.minesweeper),
    (HomeScreenApps.oceanSweep, AppRouter.oceanSweep),
  ];

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
              child: BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
                builder: (context, _) => _StreakTeaser(onTap: () => context.read<BottomNavigationBarCubit>().changeIndex(1)),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(LocaleKeys.playNow.tr(), style: context.textTheme.bodyMedium),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _activeGames.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final (item, route) = _activeGames[index];
                return PlayCard(onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(route), item: item);
              },
            ),
            const SizedBox(height: 12),
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

/// Small teaser pointing at the Daily Challenge tab so the streak mechanic
/// isn't hidden behind a tab the user might not think to check.
class _StreakTeaser extends StatelessWidget {
  final VoidCallback onTap;

  const _StreakTeaser({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final int streak = DailyChallengeService.currentStreak;
    final bool completedToday = DailyChallengeService.isCompletedToday;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orangeAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                streak > 0 ? '$streak-day streak — daily challenge' : 'Start today\'s daily challenge',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            if (completedToday)
              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18)
            else
              const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
