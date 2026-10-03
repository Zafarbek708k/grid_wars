import 'package:flutter/material.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/platformer/presentation/pages/platformer_game_page.dart';

class PlatformerHomeScreen extends StatelessWidget {
  const PlatformerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back Button to Game Hub
              Positioned(
                top: 12,
                left: 16,
                child: ClayButton(
                  compact: true,
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: 'MAIN MENU',
                  color: gameAccentColor(HomeScreenApps.mario2D),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),

              // Center Content
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber, width: 1.5),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.sports_esports, color: Colors.amber, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'CLASSIC 2D ARCADE',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Game Title
                      Text(
                        'SUPER PLATFORMER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                          color: Colors.white,
                          shadows: [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.8), blurRadius: 20, spreadRadius: 4)],
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'JUMP • RUN • REACH THE FLAG',
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 2.0),
                      ),

                      const SizedBox(height: 28),

                      // Hero Avatar Preview (Material Icons Only)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.cyanAccent, width: 2.5),
                          boxShadow: [
                            BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.4), blurRadius: 25, spreadRadius: 5),
                          ],
                        ),
                        child: const Icon(Icons.directions_run_rounded, color: Colors.cyanAccent, size: 64),
                      ),

                      const SizedBox(height: 36),

                      // PLAY BUTTON
                      SizedBox(
                        width: 220,
                        height: 54,
                        child: ClayButton(
                          expand: true,
                          icon: Icons.play_arrow_rounded,
                          label: 'PLAY NOW',
                          color: gameAccentColor(HomeScreenApps.mario2D),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlatformerGamePage()));
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Controls Tip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'Controls: On-screen buttons or Keyboard (Arrow keys + Space)',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
