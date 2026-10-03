import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ocean_session_state.dart';

/// Tracks one Ocean Sweep run. Pure in-memory state — nothing here is
/// persisted (that's OceanStatsCubit's job once a run ends). Flame only
/// ever calls these methods and reads [stream]; every rule (level-up
/// threshold, whether a hit ends the run) lives here so it's testable
/// without Flame at all.
class OceanSessionCubit extends Cubit<OceanSessionState> {
  OceanSessionCubit() : super(const OceanSessionState());

  static const int pointsPerLevel = 10;

  void start() => emit(const OceanSessionState(status: OceanStatus.playing));

  void pause() {
    if (state.isPlaying) emit(state.copyWith(status: OceanStatus.paused));
  }

  void resume() {
    if (state.status == OceanStatus.paused) {
      emit(state.copyWith(status: OceanStatus.playing));
    }
  }

  /// Plastic collected. Returns true if this collection leveled the player up.
  bool collectTrash() {
    if (!state.isPlaying) return false;
    final int score = state.score + 1;
    final int level = score ~/ pointsPerLevel + 1;
    final bool leveledUp = level > state.level;
    emit(state.copyWith(score: score, level: level));
    return leveledUp;
  }

  /// Hit by an enemy. Returns true if this hit actually ended the run
  /// (false if a shield absorbed it).
  bool hitEnemy() {
    if (!state.isPlaying || state.hasShield) return false;
    emit(state.copyWith(status: OceanStatus.gameOver, shieldSecondsLeft: 0));
    return true;
  }

  /// The shield countdown runs inside the game loop (so it pauses with the
  /// game); only whole seconds are pushed here to avoid rebuilding the HUD
  /// every frame.
  void updateShield(int secondsLeft) {
    if (secondsLeft != state.shieldSecondsLeft) {
      emit(state.copyWith(shieldSecondsLeft: secondsLeft));
    }
  }

  void backToMenu() => emit(const OceanSessionState());
}
