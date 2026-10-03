import 'dart:io';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import 'package:grid_wars/feature/ocean_sweep/domain/services/ocean_sweep_service.dart';

/// Sound/haptic feedback for one run. Every call is best-effort: a missing
/// audio asset or an unsupported vibration API must never crash the game,
/// so every side effect is wrapped and silently skipped on failure.
class OceanFeedback {
  Future<void> collect() => _playSound('ocean_collect.mp3');

  Future<void> levelUp() => _playSound('ocean_level_up.mp3');

  Future<void> shield() => _playSound('ocean_shield.mp3');

  Future<void> hit() async {
    await _playSound('ocean_hit.mp3');
    await _vibrate();
  }

  Future<void> _playSound(String fileName) async {
    if (!OceanSweepService.soundEnabled) return;
    try {
      await FlameAudio.play(fileName);
    } catch (_) {
      // Audio asset isn't bundled yet — fail silently rather than crash the run.
    }
  }

  Future<void> _vibrate() async {
    if (!OceanSweepService.vibrationEnabled) return;
    try {
      if (Platform.isIOS) {
        await HapticFeedback.mediumImpact();
      } else {
        await Vibration.vibrate(duration: 100, amplitude: 80);
      }
    } catch (_) {
      // No vibration hardware/permission — ignore.
    }
  }
}
