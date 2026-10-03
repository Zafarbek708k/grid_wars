part of 'ocean_session_cubit.dart';

enum OceanStatus { menu, playing, paused, gameOver }

class OceanSessionState extends Equatable {
  const OceanSessionState({
    this.status = OceanStatus.menu,
    this.score = 0,
    this.level = 1,
    this.shieldSecondsLeft = 0,
  });

  final OceanStatus status;
  final int score;
  final int level;
  final int shieldSecondsLeft;

  bool get isPlaying => status == OceanStatus.playing;

  bool get hasShield => shieldSecondsLeft > 0;

  OceanSessionState copyWith({
    OceanStatus? status,
    int? score,
    int? level,
    int? shieldSecondsLeft,
  }) {
    return OceanSessionState(
      status: status ?? this.status,
      score: score ?? this.score,
      level: level ?? this.level,
      shieldSecondsLeft: shieldSecondsLeft ?? this.shieldSecondsLeft,
    );
  }

  @override
  List<Object?> get props => [status, score, level, shieldSecondsLeft];
}
