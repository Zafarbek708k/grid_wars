import 'package:grid_wars/core/constants/app_icons.dart';

/// Static metadata describing what "history" means for one game: what the
/// running play-count is called, and — for games with a meaningful score —
/// what the best-value metric is called and whether lower is better
/// (e.g. fewest moves/mistakes) or higher is better (e.g. score).
class GameStatDefinition {
  final String id;
  final String title;
  final String icon;
  final String countLabel;
  final String? bestMetricLabel;
  final bool lowerIsBetter;

  const GameStatDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.countLabel,
    this.bestMetricLabel,
    this.lowerIsBetter = false,
  });
}

/// Every game in the app, in the order they should list in Profile history.
const List<GameStatDefinition> allGameStatDefinitions = [
  GameStatDefinition(id: 'ticTacToe', title: 'Tic Tac Toe', icon: AppIcons.ticTac, countLabel: 'Wins'),
  GameStatDefinition(
    id: 'math',
    title: 'Mental Math',
    icon: AppIcons.plusEqual,
    countLabel: 'Games Played',
    bestMetricLabel: 'Best Correct Answers',
  ),
  GameStatDefinition(
    id: 'fifteenPuzzle',
    title: '15 Puzzle',
    icon: AppIcons.game,
    countLabel: 'Solved',
    bestMetricLabel: 'Fewest Moves',
    lowerIsBetter: true,
  ),
  GameStatDefinition(
    id: 'sudoku',
    title: 'Sudoku',
    icon: AppIcons.sudoku,
    countLabel: 'Solved',
    bestMetricLabel: 'Fewest Mistakes',
    lowerIsBetter: true,
  ),
  GameStatDefinition(
    id: 'mario2D',
    title: 'Super Platformer',
    icon: AppIcons.game,
    countLabel: 'Levels Cleared',
    bestMetricLabel: 'Best Score',
  ),
  GameStatDefinition(
    id: 'game2048',
    title: '2048',
    icon: AppIcons.game,
    countLabel: 'Games Played',
    bestMetricLabel: 'Best Score',
  ),
  GameStatDefinition(id: 'minesweeper', title: 'Minesweeper', icon: AppIcons.game, countLabel: 'Wins'),
  GameStatDefinition(id: 'wordSearch', title: 'Word Search', icon: AppIcons.language, countLabel: 'Completed'),
  GameStatDefinition(id: 'nard', title: 'Nard', icon: AppIcons.dice5, countLabel: 'Rolls'),
];
