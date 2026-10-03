import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key, required this.onResume, required this.onExit});

  final VoidCallback onResume;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.oceanSweep);

    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pause_circle_filled, color: Colors.white, size: 56),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: ClayButton(expand: true, icon: Icons.play_arrow_rounded, label: LocaleKeys.resume.tr(), color: accent, onTap: onResume),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 200,
            child: ClayButton(expand: true, icon: Icons.close, label: LocaleKeys.exit.tr(), color: Colors.grey, onTap: onExit),
          ),
        ],
      ),
    );
  }
}
