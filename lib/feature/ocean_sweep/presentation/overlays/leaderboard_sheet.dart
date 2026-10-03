import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_stats_cubit/ocean_stats_cubit.dart';

Future<void> showLeaderboardSheet(BuildContext context) {
  final OceanStatsCubit statsCubit = context.read<OceanStatsCubit>();
  return showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0E2A3B),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) => BlocProvider.value(value: statsCubit, child: const _LeaderboardContent()),
  );
}

class _LeaderboardContent extends StatelessWidget {
  const _LeaderboardContent();

  @override
  Widget build(BuildContext context) {
    final leaderboard = context.watch<OceanStatsCubit>().state.leaderboard;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TOP DIVERS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
            const SizedBox(height: 14),
            if (leaderboard.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No runs yet — be the first!', style: TextStyle(color: Colors.white70)),
              )
            else
              ...List.generate(leaderboard.length, (index) {
                final entry = leaderboard[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(width: 28, child: Text('${index + 1}', style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))),
                      Expanded(child: Text(entry.nickname, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                      Text('${entry.score}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
