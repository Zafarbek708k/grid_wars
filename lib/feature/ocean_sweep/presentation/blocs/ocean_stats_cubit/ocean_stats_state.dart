part of 'ocean_stats_cubit.dart';

class OceanStatsState extends Equatable {
  const OceanStatsState({
    this.nickname = '',
    this.highScore = 0,
    this.leaderboard = const [],
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.lastIsNewHighScore = false,
  });

  final String nickname;
  final int highScore;
  final List<ScoreEntry> leaderboard;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool lastIsNewHighScore;

  bool get needsNickname => nickname.isEmpty;

  OceanStatsState copyWith({
    String? nickname,
    int? highScore,
    List<ScoreEntry>? leaderboard,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? lastIsNewHighScore,
  }) {
    return OceanStatsState(
      nickname: nickname ?? this.nickname,
      highScore: highScore ?? this.highScore,
      leaderboard: leaderboard ?? this.leaderboard,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      lastIsNewHighScore: lastIsNewHighScore ?? this.lastIsNewHighScore,
    );
  }

  @override
  List<Object?> get props => [nickname, highScore, leaderboard, soundEnabled, vibrationEnabled, lastIsNewHighScore];
}
