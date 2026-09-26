import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/game_stats/domain/entities/game_stat_definition.dart';
import 'package:grid_wars/feature/game_stats/domain/entities/game_stat_snapshot.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/profile_card.dart';

/// Per-game play history: how many times each game has been completed, its
/// best value (where one applies), and when it was last played.
class GameHistoryCard extends StatelessWidget {
  const GameHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(child: Icon(Icons.history, color: AppColors.white)),
                const WidgetSpan(child: SizedBox(width: 6)),
                TextSpan(text: 'Game History', style: context.textTheme.headlineMedium),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < allGameStatDefinitions.length; i++) ...[
            if (i > 0) const Divider(height: 18, color: Colors.white12),
            _GameHistoryRow(definition: allGameStatDefinitions[i]),
          ],
        ],
      ),
    );
  }
}

class _GameHistoryRow extends StatelessWidget {
  final GameStatDefinition definition;

  const _GameHistoryRow({required this.definition});

  String _lastPlayedLabel(DateTime? lastPlayed) {
    if (lastPlayed == null) return 'Not played yet';

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime day = DateTime(lastPlayed.year, lastPlayed.month, lastPlayed.day);
    final int diff = today.difference(day).inDays;

    if (diff == 0) return 'Last played today';
    if (diff == 1) return 'Last played yesterday';
    return 'Last played $diff days ago';
  }

  @override
  Widget build(BuildContext context) {
    final GameStatSnapshot stats = GameStatsService.getStats(definition.id);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          definition.icon,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(
            stats.hasEverPlayed ? AppColors.cyan : AppColors.white.withValues(alpha: 0.35),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(definition.title, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                _lastPlayedLabel(stats.lastPlayed),
                style: context.textTheme.bodySmall?.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${definition.countLabel}: ${stats.timesCompleted}',
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.white, fontWeight: FontWeight.w700),
            ),
            if (definition.bestMetricLabel != null && stats.bestValue != null)
              Text(
                '${definition.bestMetricLabel}: ${stats.bestValue}',
                style: context.textTheme.bodySmall?.copyWith(color: AppColors.grey),
              ),
          ],
        ),
      ],
    );
  }
}
