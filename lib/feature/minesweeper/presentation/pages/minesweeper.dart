import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/minesweeper/presentation/blocs/minesweeper_bloc/minesweeper_bloc.dart';

class Minesweeper extends StatelessWidget {
  const Minesweeper({super.key});

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
          'Minesweeper',
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
          child: BlocConsumer<MinesweeperBloc, MinesweeperState>(
            listener: (context, state) {
              if (state.isWin) {
                final bloc = context.read<MinesweeperBloc>();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => BlocProvider.value(value: bloc, child: const _ResultDialog(isWin: true)),
                );
              } else if (state.isGameOver) {
                final bloc = context.read<MinesweeperBloc>();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => BlocProvider.value(value: bloc, child: const _ResultDialog(isWin: false)),
                );
              }
            },
            builder: (context, state) {
              if (state.board.isEmpty) return const SizedBox.shrink();

              return Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: MinesweeperDifficulty.values.map((difficulty) {
                      final bool isSelected = state.difficulty == difficulty;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedButton(
                          onTap: () => context.read<MinesweeperBloc>().add(SelectDifficulty$MinesweeperEvent(difficulty: difficulty)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.cyanAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? Colors.cyanAccent : Colors.white24, width: 1.5),
                            ),
                            child: Text(
                              difficulty.label,
                              style: TextStyle(
                                color: isSelected ? Colors.cyanAccent : Colors.white70,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flag, color: Colors.redAccent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${state.difficulty.mineCount - state.flaggedCount}',
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.difficulty.rows * state.difficulty.cols,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: state.difficulty.cols, crossAxisSpacing: 1, mainAxisSpacing: 1),
                            itemBuilder: (context, index) {
                              final int row = index ~/ state.difficulty.cols;
                              final int col = index % state.difficulty.cols;
                              return _CellWidget(
                                cell: state.board[row][col],
                                onTap: () => context.read<MinesweeperBloc>().add(RevealCell$MinesweeperEvent(row: row, col: col)),
                                onLongPress: () => context.read<MinesweeperBloc>().add(ToggleFlag$MinesweeperEvent(row: row, col: col)),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Tap to reveal • Long-press to flag', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ),
                  const SizedBox(height: 70),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () => context.read<MinesweeperBloc>().add(const ResetGame$MinesweeperEvent()),
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

class _CellWidget extends StatelessWidget {
  final MineCell cell;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CellWidget({required this.cell, required this.onTap, required this.onLongPress});

  static const List<Color> _numberColors = [
    Colors.transparent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.cyanAccent,
    Colors.white,
    Colors.white54,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: cell.isRevealed ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(3),
        ),
        alignment: Alignment.center,
        child: cell.isFlagged
            ? const Icon(Icons.flag, color: Colors.redAccent, size: 14)
            : !cell.isRevealed
            ? null
            : cell.isMine
            ? const Icon(Icons.brightness_1, color: Colors.black87, size: 12)
            : cell.adjacentMines == 0
            ? null
            : Text(
                '${cell.adjacentMines}',
                style: TextStyle(
                  color: _numberColors[cell.adjacentMines.clamp(0, 8)],
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final bool isWin;

  const _ResultDialog({required this.isWin});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 190,
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
              Text(
                isWin ? LocaleKeys.youWin.tr() : 'BOOM!',
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<MinesweeperBloc>().add(const ResetGame$MinesweeperEvent());
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
