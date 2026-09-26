import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/presentation/controllers/game_controller.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/game_background.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/game_controls.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/game_hud.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/coin_widget.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/game_overlays.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/platform_widget.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/player_widget.dart';
import 'package:grid_wars/feature/platformer/presentation/widgets/power_up_widget.dart';

class PlatformerGamePage extends StatefulWidget {
  const PlatformerGamePage({super.key});

  @override
  State<PlatformerGamePage> createState() => _PlatformerGamePageState();
}

class _PlatformerGamePageState extends State<PlatformerGamePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final GameController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Lock to landscape mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    _controller = GameController(vsync: this);
    _controller.startGame();

    // Focus for keyboard input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _controller.pauseGame();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _controller.dispose();

    // Restore orientation settings
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
        _controller.onLeftDown();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
        _controller.onRightDown();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        _controller.jump();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        if (_controller.status == GameStatus.playing) {
          _controller.pauseGame();
        } else if (_controller.status == GameStatus.paused) {
          _controller.resumeGame();
        }
        return KeyEventResult.handled;
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
        _controller.onLeftUp();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
        _controller.onRightUp();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Upper Area: Scaled Game World
              Expanded(
                flex: 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double viewportWidth = constraints.maxWidth;
                    final double viewportHeight = constraints.maxHeight;

                    _controller.updateViewportWidth(viewportWidth);

                    // Dynamic scale to fit virtualWorldHeight
                    final double scaleY = viewportHeight / GameConfig.virtualWorldHeight;

                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final double cameraX = _controller.cameraX;

                        return ClipRect(
                          child: Stack(
                            children: [
                              // 1. Sky & Parallax background
                              Positioned.fill(
                                child: GameBackground(cameraX: cameraX, worldHeight: GameConfig.virtualWorldHeight),
                              ),

                              // 2. World Elements (Scaled & Camera-offset)
                              Transform.scale(
                                scale: scaleY,
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width: viewportWidth / scaleY,
                                  height: GameConfig.virtualWorldHeight,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                    // Platforms & Ground
                                    ..._controller.level.platforms.map((platform) {
                                      final double screenX = platform.x - cameraX;
                                      // Render culling
                                      if (screenX + platform.width < -100 || screenX > (viewportWidth / scaleY) + 100) {
                                        return const SizedBox.shrink();
                                      }

                                      return Positioned(
                                        left: screenX,
                                        top: platform.y,
                                        child: PlatformWidget(platform: platform),
                                      );
                                    }),

                                    // Coins
                                    ..._controller.level.coins.where((coin) => !coin.collected).map((coin) {
                                      final double screenX = coin.x - cameraX;
                                      if (screenX + coin.width < -100 || screenX > (viewportWidth / scaleY) + 100) {
                                        return const SizedBox.shrink();
                                      }
                                      return Positioned(
                                        left: screenX,
                                        top: coin.y,
                                        child: CoinWidget(coin: coin),
                                      );
                                    }),

                                    // Power-ups popped out of question blocks
                                    ..._controller.activePowerUps.map((powerUp) {
                                      final double screenX = powerUp.x - cameraX;
                                      return Positioned(
                                        left: screenX,
                                        top: powerUp.y,
                                        child: PowerUpWidget(powerUp: powerUp),
                                      );
                                    }),

                                    // Finish Flag
                                    Positioned(
                                      left: _controller.level.finishPoint.x - cameraX,
                                      top: _controller.level.finishPoint.y,
                                      child: FinishFlagWidget(
                                        width: _controller.level.finishPoint.width,
                                        height: _controller.level.finishPoint.height,
                                      ),
                                    ),

                                    // Player
                                    Positioned(
                                      left: _controller.player.x - cameraX,
                                      top: _controller.player.y,
                                      child: PlayerWidget(player: _controller.player),
                                    ),
                                    ],
                                  ),
                                ),
                              ),

                              // 3. HUD (Overlayed above game world)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: GameHud(
                                  score: _controller.player.score,
                                  coins: _controller.coins,
                                  world: _controller.level.title,
                                  time: _controller.timeRemaining,
                                  lives: _controller.player.lives,
                                  onPause: _controller.pauseGame,
                                ),
                              ),

                              // 4. State Overlays
                              if (_controller.status == GameStatus.paused)
                                Positioned.fill(
                                  child: PauseOverlay(
                                    onResume: _controller.resumeGame,
                                    onRestart: _controller.restartLevel,
                                    onExit: () => Navigator.of(context).pop(),
                                  ),
                                ),

                              if (_controller.status == GameStatus.gameOver)
                                Positioned.fill(
                                  child: GameOverOverlay(
                                    score: _controller.player.score,
                                    onRestart: _controller.restartLevel,
                                    onExit: () => Navigator.of(context).pop(),
                                  ),
                                ),

                              if (_controller.status == GameStatus.levelComplete)
                                Positioned.fill(
                                  child: LevelCompleteOverlay(
                                    score: _controller.player.score,
                                    timeRemaining: _controller.timeRemaining,
                                    isLastLevel: _controller.isLastLevel,
                                    onNextLevel: _controller.nextLevel,
                                    onRestart: _controller.restartLevel,
                                    onExit: () => Navigator.of(context).pop(),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Lower Area: Touch Controls
              Expanded(
                flex: 1,
                child: GameControls(
                  onLeftDown: _controller.onLeftDown,
                  onLeftUp: _controller.onLeftUp,
                  onRightDown: _controller.onRightDown,
                  onRightUp: _controller.onRightUp,
                  onJump: _controller.jump,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
