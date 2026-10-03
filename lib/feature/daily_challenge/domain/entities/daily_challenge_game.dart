import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/core/router/app_router.dart';

/// One rotation slot in the Daily Challenge: a game with a clear win state,
/// what "today's goal" looks like in it, and where to launch it from.
/// `id` is a stable key (independent of the display title) used to match a
/// completed game back to whichever game is featured today.
class DailyChallengeGame {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String route;

  const DailyChallengeGame({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}

/// Games with no clear win condition (Nard is a dice-count companion, not a
/// win/lose game) are excluded from the rotation.
const List<DailyChallengeGame> dailyChallengeGames = [
  DailyChallengeGame(
    id: 'ticTacToe',
    title: 'Tic Tac Toe',
    description: 'Win a round',
    icon: AppIcons.ticTac,
    route: AppRouter.xAndO,
  ),
  DailyChallengeGame(
    id: 'math',
    title: 'Mental Math',
    description: 'Get through today\'s question set',
    icon: AppIcons.plusEqual,
    route: AppRouter.mental,
  ),
  DailyChallengeGame(
    id: 'fifteenPuzzle',
    title: '15 Puzzle',
    description: 'Solve the sliding puzzle',
    icon: AppIcons.game,
    route: AppRouter.puzzle15,
  ),
  DailyChallengeGame(
    id: 'sudoku',
    title: 'Sudoku',
    description: "Solve today's Sudoku",
    icon: AppIcons.sudoku,
    route: AppRouter.sudoku,
  ),
  DailyChallengeGame(
    id: 'mario2D',
    title: 'Super Platformer',
    description: 'Clear a level',
    icon: AppIcons.game,
    route: AppRouter.platformer,
  ),
  DailyChallengeGame(
    id: 'game2048',
    title: '2048',
    description: 'Reach the 2048 tile',
    icon: AppIcons.game,
    route: AppRouter.game2048,
  ),
  DailyChallengeGame(
    id: 'minesweeper',
    title: 'Minesweeper',
    description: 'Clear the minefield',
    icon: AppIcons.game,
    route: AppRouter.minesweeper,
  ),
  DailyChallengeGame(
    id: 'wordSearch',
    title: 'Word Search',
    description: 'Find every hidden word',
    icon: AppIcons.language,
    route: AppRouter.wordSearch,
  ),
  DailyChallengeGame(
    id: 'oceanSweep',
    title: 'Ocean Sweep',
    description: 'Collect plastic and survive a run',
    icon: AppIcons.game,
    route: AppRouter.oceanSweep,
  ),
];
