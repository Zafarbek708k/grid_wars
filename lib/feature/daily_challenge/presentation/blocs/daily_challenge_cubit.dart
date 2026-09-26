import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/daily_challenge/domain/entities/daily_challenge_game.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';

class DailyChallengeState extends Equatable {
  final DailyChallengeGame game;
  final bool isCompletedToday;
  final int currentStreak;
  final int longestStreak;
  final int totalCompleted;
  final List<bool> lastSevenDays;

  const DailyChallengeState({
    required this.game,
    required this.isCompletedToday,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompleted,
    required this.lastSevenDays,
  });

  @override
  List<Object?> get props => [game.id, isCompletedToday, currentStreak, longestStreak, totalCompleted, lastSevenDays];
}

/// Thin wrapper over [DailyChallengeService] so the UI can rebuild on
/// `refresh()` (called on tab entry and after returning from the featured
/// game) without re-reading storage on every build.
class DailyChallengeCubit extends Cubit<DailyChallengeState> {
  DailyChallengeCubit() : super(_read());

  static DailyChallengeState _read() {
    return DailyChallengeState(
      game: DailyChallengeService.todayGame,
      isCompletedToday: DailyChallengeService.isCompletedToday,
      currentStreak: DailyChallengeService.currentStreak,
      longestStreak: DailyChallengeService.longestStreak,
      totalCompleted: DailyChallengeService.totalCompleted,
      lastSevenDays: DailyChallengeService.lastSevenDays(),
    );
  }

  void refresh() => emit(_read());
}
