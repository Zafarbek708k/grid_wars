import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/feature/game/presentation/pages/x_and_o.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const XAndO()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: AppColors.black.withValues(alpha: 0.1)),
          ),

          ScaleTransition(
            scale: _scale,
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 2),
                boxShadow: [BoxShadow(color: AppColors.cyan.withValues(alpha: 0.6), blurRadius: 40, spreadRadius: 5)],
              ),
              child: SvgPicture.asset(
                AppIcons.x, // X icon
                width: 150,
                height: 150,
                colorFilter: const ColorFilter.mode(AppColors.cyan, BlendMode.srcIn),
              ),
            ),
          ),

          /// APP NAME (BOTTOM FADE)
          Positioned(
            bottom: 60,
            child: FadeTransition(
              opacity: _scale,
              child: Text(
                "Tic Tac Toe",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
