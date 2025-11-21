import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/feature/game/presentation/pages/menu.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Delay navigation
    _navigateToMenu();
  }

  Future<void> _navigateToMenu() async {
    await Future.delayed(const Duration(seconds: 2000));
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Menu()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyan,
      body: Center(
        child: ScaleTransition(scale: _scaleAnimation, child: SvgPicture.asset(AppIcons.logo, width: 200, height: 200)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
