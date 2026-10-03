import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/ocean_sweep/game/ocean_feedback.dart';
import 'package:grid_wars/feature/ocean_sweep/game/ocean_game.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_session_cubit/ocean_session_cubit.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/blocs/ocean_stats_cubit/ocean_stats_cubit.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/overlays/game_over_overlay.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/overlays/hud_overlay.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/overlays/leaderboard_sheet.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/overlays/menu_overlay.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/overlays/pause_overlay.dart';

class OceanSweepPage extends StatelessWidget {
  const OceanSweepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OceanSessionCubit()),
        BlocProvider(create: (_) => OceanStatsCubit()..load()),
      ],
      child: const _OceanSweepView(),
    );
  }
}

class _OceanSweepView extends StatefulWidget {
  const _OceanSweepView();

  @override
  State<_OceanSweepView> createState() => _OceanSweepViewState();
}

class _OceanSweepViewState extends State<_OceanSweepView> {
  late final OceanGame _game;

  @override
  void initState() {
    super.initState();
    // The diver's drag range and the HUD layout are both portrait-only —
    // lock it the same way the platformer page locks landscape.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _game = OceanGame(session: context.read<OceanSessionCubit>(), feedback: OceanFeedback());
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _startRun() {
    _game.reset();
    context.read<OceanSessionCubit>().start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OceanSessionCubit, OceanSessionState>(
        listenWhen: (previous, current) => previous.status != OceanStatus.gameOver && current.status == OceanStatus.gameOver,
        listener: (context, state) => context.read<OceanStatsCubit>().submitScore(state.score),
        // Scaffold.body gives loose constraints, and the HUD/menu overlays
        // below are plain (non-Positioned) Stack children — without this,
        // the Stack shrink-wraps to their content height instead of filling
        // the screen, and GameWidget (Positioned.fill) shrinks with it.
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(child: GameWidget(game: _game)),
              BlocBuilder<OceanSessionCubit, OceanSessionState>(
                builder: (context, state) {
                  return switch (state.status) {
                    OceanStatus.menu => MenuOverlay(onPlay: _startRun, onShowLeaderboard: () => showLeaderboardSheet(context)),
                    OceanStatus.playing => HudOverlay(state: state, onPause: () => context.read<OceanSessionCubit>().pause()),
                    OceanStatus.paused => PauseOverlay(
                      onResume: () => context.read<OceanSessionCubit>().resume(),
                      onExit: () => Navigator.of(context).pop(),
                    ),
                    OceanStatus.gameOver => GameOverOverlay(
                      score: state.score,
                      onPlayAgain: _startRun,
                      onExit: () => Navigator.of(context).pop(),
                      onShowLeaderboard: () => showLeaderboardSheet(context),
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
