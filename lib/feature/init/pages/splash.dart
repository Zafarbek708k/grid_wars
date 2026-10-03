import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/feature/navigation/main_navigation.dart';
import 'package:grid_wars/feature/settings/presentation/blocs/app_config_bloc/app_config_bloc.dart';

/// Icons of a few of the games in the hub, orbiting the logo as a quick
/// visual hint that this is a multi-game app — not just one game.
const List<String> _orbitIcons = [AppIcons.dice5, AppIcons.sudoku, AppIcons.plusEqual, AppIcons.brain, AppIcons.ticTac];

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  // Drives the one-shot staged entrance (logo pop, orbit fade-in, text,
  // loader), split into stages via Interval below.
  late final AnimationController _entrance;
  // Continuous glow pulse behind the logo and for the loading dots.
  late final AnimationController _pulse;
  // Continuous slow spin for the orbiting icons and the background gradient.
  late final AnimationController _spin;

  late final Animation<double> _logoScale;
  late final Animation<double> _orbitFade;
  late final Animation<double> _nameFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();
    context.read<AppConfigBloc>().add(InitializeConfigEvent());

    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 1700))..forward();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat(reverse: true);
    _spin = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();

    _logoScale = CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.55, curve: Curves.elasticOut));
    _orbitFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.1, 0.5, curve: Curves.easeOut));
    _nameFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.45, 0.8, curve: Curves.easeOut));
    _nameSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(_nameFade);
    _taglineFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.6, 0.95, curve: Curves.easeOut));
    _loaderFade = CurvedAnimation(parent: _entrance, curve: const Interval(0.8, 1.0, curve: Curves.easeOut));

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2600));
    if (mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainNavigation()), (_) => false);
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
          // Slowly drifting gradient background.
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _spin,
              builder: (context, _) {
                final double t = _spin.value * 2 * math.pi;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1 + 0.5 * math.cos(t), -1 + 0.5 * math.sin(t)),
                      end: Alignment(1 - 0.5 * math.cos(t), 1 - 0.5 * math.sin(t)),
                      colors: const [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: AppColors.black.withValues(alpha: 0.08)),
            ),
          ),

          // Orbiting game icons, hinting this is a hub of games.
          AnimatedBuilder(
            animation: Listenable.merge([_spin, _orbitFade]),
            builder: (context, _) {
              return Opacity(
                opacity: _orbitFade.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(_orbitIcons.length, (i) {
                    final double angle = _spin.value * 2 * math.pi + (2 * math.pi / _orbitIcons.length) * i;
                    const double radius = 128.0;
                    return Transform.translate(
                      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
                      child: Opacity(
                        opacity: 0.55,
                        child: SvgPicture.asset(
                          _orbitIcons[i],
                          width: 26,
                          height: 26,
                          colorFilter: const ColorFilter.mode(AppColors.cyan, BlendMode.srcIn),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),

          // Pulsing glow behind the logo.
          AnimatedBuilder(
            animation: Listenable.merge([_pulse, _logoScale]),
            builder: (context, _) => Transform.scale(
              scale: _logoScale.value,
              child: Container(
                width: 190 + 18 * _pulse.value,
                height: 190 + 18 * _pulse.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.cyan.withValues(alpha: 0.35 + 0.25 * _pulse.value), blurRadius: 50, spreadRadius: 6),
                  ],
                ),
              ),
            ),
          ),

          // Main logo.
          ScaleTransition(
            scale: _logoScale,
            child: Container(
              padding: const EdgeInsets.all(34),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white.withValues(alpha: 0.25), width: 2),
              ),
              child: SvgPicture.asset(
                AppIcons.game,
                width: 110,
                height: 110,
                colorFilter: const ColorFilter.mode(AppColors.cyan, BlendMode.srcIn),
              ),
            ),
          ),

          // App name, tagline, and loading indicator.
          Positioned(
            bottom: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SlideTransition(
                  position: _nameSlide,
                  child: FadeTransition(
                    opacity: _nameFade,
                    child: const Text(
                      'GRID WARS',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _taglineFade,
                  child: Text(
                    'PLAY · COMPETE · HAVE FUN',
                    style: TextStyle(fontSize: 12, letterSpacing: 3, color: AppColors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 26),
                FadeTransition(opacity: _loaderFade, child: _LoadingDots(pulse: _pulse)),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  final Animation<double> pulse;

  const _LoadingDots({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final double t = (pulse.value + i * 0.33) % 1.0;
            final double scale = 0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.cyan),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
