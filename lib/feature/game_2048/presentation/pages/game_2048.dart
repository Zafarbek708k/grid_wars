import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/game_2048/presentation/blocs/game2048_bloc/game2048_bloc.dart';

class Game2048 extends StatelessWidget {
  const Game2048({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          '2048',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: AnimatedButton(
          child: Icon(Icons.arrow_back_ios, color: context.themeExtension.whiteToCyan),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<Game2048Bloc, Game2048State>(
            listener: (context, state) {
              if (state.hasWon) {
                final bloc = context.read<Game2048Bloc>();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: _ResultDialog(title: LocaleKeys.youWin.tr(), score: state.score),
                  ),
                );
              } else if (state.isGameOver) {
                final bloc = context.read<Game2048Bloc>();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => BlocProvider.value(value: bloc, child: _ResultDialog(title: 'GAME OVER', score: state.score)),
                );
              }
            },
            builder: (context, state) {
              if (state.board.isEmpty) return const SizedBox.shrink();

              return GestureDetector(
                onVerticalDragEnd: (details) {
                  final double? velocity = details.primaryVelocity;
                  if (velocity == null || velocity.abs() < 100) return;
                  context.read<Game2048Bloc>().add(
                    Move$Game2048Event(direction: velocity > 0 ? SwipeDirection.down : SwipeDirection.up),
                  );
                },
                onHorizontalDragEnd: (details) {
                  final double? velocity = details.primaryVelocity;
                  if (velocity == null || velocity.abs() < 100) return;
                  context.read<Game2048Bloc>().add(
                    Move$Game2048Event(direction: velocity > 0 ? SwipeDirection.right : SwipeDirection.left),
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatChip(label: 'SCORE', value: '${state.score}'),
                        const SizedBox(width: 16),
                        _StatChip(label: 'BEST', value: '${state.best}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B1620),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 16,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6,
                                ),
                                itemBuilder: (context, index) {
                                  final int value = state.board[index ~/ 4][index % 4];
                                  return _Tile(value: value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Swipe to move tiles', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () => context.read<Game2048Bloc>().add(const NewGame$Game2048Event()),
        child: Container(
          height: 48,
          margin: EdgeInsetsGeometry.fromLTRB(16, 0, 16, context.padding.bottom + 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors: [Colors.cyanAccent.withValues(alpha: 0.5), Colors.blueAccent.withValues(alpha: 0.5)]),
            boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.3), offset: const Offset(3, 3), blurRadius: 6)],
            border: Border.all(color: AppColors.white.withValues(alpha: 0.4), width: 1.2),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, color: AppColors.white),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.resetGame.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final int value;

  const _Tile({required this.value});

  static const Map<int, Color> _colors = {
    2: Color(0xFFEEE4DA),
    4: Color(0xFFEDE0C8),
    8: Color(0xFFF2B179),
    16: Color(0xFFF59563),
    32: Color(0xFFF67C5F),
    64: Color(0xFFF65E3B),
    128: Color(0xFFEDCF72),
    256: Color(0xFFEDCC61),
    512: Color(0xFFEDC850),
    1024: Color(0xFFEDC53F),
    2048: Color(0xFFEDC22E),
  };

  @override
  Widget build(BuildContext context) {
    final Color background = value == 0 ? Colors.white.withValues(alpha: 0.05) : (_colors[value] ?? const Color(0xFF3C3A32));
    final Color textColor = value <= 4 ? const Color(0xFF6b6355) : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: value == 0
          ? null
          : Text(
              '$value',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: value >= 1024 ? 18 : 22),
            ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final String title;
  final int score;

  const _ResultDialog({required this.title, required this.score});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 200,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('SCORE: $score', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<Game2048Bloc>().add(const NewGame$Game2048Event());
                    },
                    child: Text(LocaleKeys.playAgain.tr()),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text(LocaleKeys.backToHome.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
