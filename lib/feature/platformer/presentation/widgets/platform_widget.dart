import 'package:flutter/material.dart';
import 'package:grid_wars/feature/platformer/config/game_config.dart';
import 'package:grid_wars/feature/platformer/domain/entities/platform_model.dart';

class PlatformWidget extends StatelessWidget {
  final PlatformModel platform;

  const PlatformWidget({super.key, required this.platform});

  @override
  Widget build(BuildContext context) {
    switch (platform.type) {
      case PlatformType.ground:
        return _buildGround();
      case PlatformType.brick:
        return _buildBrick();
      case PlatformType.pipe:
        return _buildPipe();
      case PlatformType.floating:
        return _buildFloating();
      case PlatformType.questionBlock:
        return _buildQuestionBlock();
    }
  }

  Widget _buildGround() {
    return Container(
      width: platform.width,
      height: platform.height,
      decoration: BoxDecoration(
        color: GameConfig.groundDirtColor,
        border: const Border(
          top: BorderSide(color: GameConfig.groundGrassColor, width: 8.0),
          left: BorderSide(color: Color(0xFF6B2406), width: 1.0),
          right: BorderSide(color: Color(0xFF6B2406), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          (platform.width ~/ 60).clamp(1, 40),
          (index) => const Icon(
            Icons.grass,
            color: Color(0xFF007500),
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFloating() {
    return Container(
      width: platform.width,
      height: platform.height,
      decoration: BoxDecoration(
        color: const Color(0xFF3B5998),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.cyanAccent, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.45),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.horizontal_rule, color: Colors.cyanAccent, size: 20),
        ],
      ),
    );
  }

  Widget _buildBrick() {
    return Container(
      width: platform.width,
      height: platform.height,
      decoration: BoxDecoration(
        color: GameConfig.brickColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF5A1E02), width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.grid_4x4, color: Color(0xFF5A1E02), size: 22),
      ),
    );
  }

  Widget _buildQuestionBlock() {
    final bool isUsed = platform.isUsed;
    return Container(
      width: platform.width,
      height: platform.height,
      decoration: BoxDecoration(
        color: isUsed ? GameConfig.usedBlockColor : GameConfig.questionBlockColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF8B5A00), width: 2.0),
        boxShadow: isUsed
            ? null
            : const [
                BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
              ],
      ),
      child: Center(
        child: isUsed
            ? null
            : const Text(
                '?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
      ),
    );
  }

  Widget _buildPipe() {
    return Container(
      width: platform.width,
      height: platform.height,
      decoration: BoxDecoration(
        color: const Color(0xFF00A800),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border.all(color: const Color(0xFF005500), width: 3.0),
      ),
    );
  }
}
