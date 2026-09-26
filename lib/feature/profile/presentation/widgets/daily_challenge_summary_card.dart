import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/profile_card.dart';

/// Read-only summary of the Daily Challenge streak, for the Profile screen.
/// The full interactive view (today's featured game, 7-day strip) lives in
/// the Daily Challenge tab itself.
class DailyChallengeSummaryCard extends StatelessWidget {
  const DailyChallengeSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(child: Icon(Icons.local_fire_department, color: Colors.orangeAccent)),
                const WidgetSpan(child: SizedBox(width: 6)),
                TextSpan(text: 'Daily Challenge', style: context.textTheme.headlineMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Stat(label: 'STREAK', value: '${DailyChallengeService.currentStreak}', color: Colors.orangeAccent),
              ),
              Expanded(
                child: _Stat(label: 'BEST', value: '${DailyChallengeService.longestStreak}', color: Colors.amberAccent),
              ),
              Expanded(
                child: _Stat(label: 'TOTAL', value: '${DailyChallengeService.totalCompleted}', color: Colors.greenAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
      ],
    );
  }
}
