/// A single game's persisted history: how many times it's been completed,
/// the best value reached (meaning depends on [GameStatDefinition]), and
/// when it was last played.
class GameStatSnapshot {
  final int timesCompleted;
  final int? bestValue;
  final DateTime? lastPlayed;

  const GameStatSnapshot({required this.timesCompleted, this.bestValue, this.lastPlayed});

  bool get hasEverPlayed => timesCompleted > 0;
}
