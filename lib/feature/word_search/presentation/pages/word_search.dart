import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/word_search/presentation/blocs/word_search_bloc/word_search_bloc.dart';

class WordSearch extends StatelessWidget {
  const WordSearch({super.key});

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
          'Word Search',
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
          child: BlocConsumer<WordSearchBloc, WordSearchState>(
            listener: (context, state) {
              if (state.isSolved) {
                final bloc = context.read<WordSearchBloc>();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => BlocProvider.value(value: bloc, child: const _WinDialog()),
                );
              }
            },
            builder: (context, state) {
              if (state.grid.isEmpty) return const SizedBox.shrink();

              final int size = state.grid.length;

              return Column(
                children: [
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 6,
                    children: state.words.map((word) {
                      final bool found = state.foundWords.contains(word);
                      return Text(
                        word,
                        style: TextStyle(
                          color: found ? Colors.greenAccent : Colors.white70,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          decoration: found ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final double cellSize = constraints.maxWidth / size;

                              (int, int) cellAt(Offset localPosition) {
                                final int row = (localPosition.dy / cellSize).floor().clamp(0, size - 1);
                                final int col = (localPosition.dx / cellSize).floor().clamp(0, size - 1);
                                return (row, col);
                              }

                              return GestureDetector(
                                onPanStart: (details) {
                                  final (row, col) = cellAt(details.localPosition);
                                  context.read<WordSearchBloc>().add(StartSelection$WordSearchEvent(row: row, col: col));
                                },
                                onPanUpdate: (details) {
                                  final (row, col) = cellAt(details.localPosition);
                                  context.read<WordSearchBloc>().add(UpdateSelection$WordSearchEvent(row: row, col: col));
                                },
                                onPanEnd: (_) => context.read<WordSearchBloc>().add(const EndSelection$WordSearchEvent()),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0B1620),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: size * size,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: size),
                                    itemBuilder: (context, index) {
                                      final int row = index ~/ size;
                                      final int col = index % size;
                                      final bool isSelected = state.isSelected(row, col);
                                      final bool isFound = state.isFound(row, col);

                                      return Container(
                                        margin: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.cyanAccent.withValues(alpha: 0.4)
                                              : isFound
                                              ? Colors.greenAccent.withValues(alpha: 0.25)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          state.grid[row][col],
                                          style: TextStyle(
                                            color: isFound ? Colors.greenAccent : Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Drag across letters to find a word', style: TextStyle(color: Colors.white38, fontSize: 12)),
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
        onTap: () => context.read<WordSearchBloc>().add(const NewGame$WordSearchEvent()),
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

class _WinDialog extends StatelessWidget {
  const _WinDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 180,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<WordSearchBloc>().add(const NewGame$WordSearchEvent());
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
