import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/sudoku/domain/entities/sudoku_difficulty.dart';
import 'package:grid_wars/feature/sudoku/presentation/blocs/sudoku_bloc/sudoku_bloc.dart';

class Sudoku extends StatelessWidget {
  const Sudoku({super.key});

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
          'Sudoku',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
          color: gameAccentColor(HomeScreenApps.sudoku),
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
          child: BlocConsumer<SudokuBloc, SudokuState>(
            listener: (context, state) {
              if (state.isSolved) {
                final bloc = context.read<SudokuBloc>();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => BlocProvider.value(value: bloc, child: _WinDialog(mistakes: state.mistakes)),
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
                    children: SudokuDifficulty.values.map((difficulty) {
                      final bool isSelected = state.difficulty == difficulty;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedButton(
                          onTap: () => context.read<SudokuBloc>().add(NewGame$SudokuEvent(difficulty: difficulty)),
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
                  Text(
                    'MISTAKES: ${state.mistakes}',
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _SudokuGrid(state: state),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _NumberPad(state: state),
                  const SizedBox(height: 90),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClayResetButton(
        onTap: () => context.read<SudokuBloc>().add(const ResetGame$SudokuEvent()),
        label: LocaleKeys.resetGame.tr(),
        color: gameAccentColor(HomeScreenApps.sudoku),
      ),
    );
  }
}

class _SudokuGrid extends StatelessWidget {
  final SudokuState state;

  const _SudokuGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white70, width: 2)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 81,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
        itemBuilder: (context, index) {
          final int row = index ~/ 9;
          final int col = index % 9;
          final int value = state.board[row][col];
          final bool isGiven = state.isGiven(row, col);
          final bool isSelected = state.selectedRow == row && state.selectedCol == col;
          final bool isPeer = state.selectedRow == row || state.selectedCol == col;
          final bool hasError = value != 0 && !isGiven && state.hasError(row, col);

          return GestureDetector(
            onTap: () => context.read<SudokuBloc>().add(SelectCell$SudokuEvent(row: row, col: col)),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.cyanAccent.withValues(alpha: 0.25)
                    : isPeer
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.03),
                border: Border(
                  right: BorderSide(color: Colors.white.withValues(alpha: (col + 1) % 3 == 0 ? 0.7 : 0.15), width: (col + 1) % 3 == 0 ? 1.5 : 0.5),
                  bottom: BorderSide(color: Colors.white.withValues(alpha: (row + 1) % 3 == 0 ? 0.7 : 0.15), width: (row + 1) % 3 == 0 ? 1.5 : 0.5),
                ),
              ),
              alignment: Alignment.center,
              child: value == 0
                  ? null
                  : Text(
                      '$value',
                      style: TextStyle(
                        color: hasError ? Colors.redAccent : (isGiven ? Colors.white : Colors.cyanAccent),
                        fontWeight: isGiven ? FontWeight.w700 : FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final SudokuState state;

  const _NumberPad({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (int value = 1; value <= 9; value++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: AnimatedButton(
                  onTap: () => context.read<SudokuBloc>().add(InputNumber$SudokuEvent(value: value)),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    alignment: Alignment.center,
                    child: Text('$value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedButton(
              onTap: () => context.read<SudokuBloc>().add(const Erase$SudokuEvent()),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.backspace_outlined, color: Colors.redAccent, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WinDialog extends StatelessWidget {
  final int mistakes;

  const _WinDialog({required this.mistakes});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 220,
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
              Text(LocaleKeys.youWin.tr(), style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('$mistakes mistakes', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClayButton(
                    compact: true,
                    icon: Icons.replay_rounded,
                    color: gameAccentColor(HomeScreenApps.sudoku),
                    label: LocaleKeys.playAgain.tr(),
                    onTap: () {
                      final difficulty = context.read<SudokuBloc>().state.difficulty;
                      Navigator.of(context).pop();
                      context.read<SudokuBloc>().add(NewGame$SudokuEvent(difficulty: difficulty));
                    },
                  ),
                  ClayButton(
                    compact: true,
                    icon: Icons.home_rounded,
                    color: AppColors.grey,
                    label: LocaleKeys.backToHome.tr(),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
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
