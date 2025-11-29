import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/game/presentation/blocs/x_o_bloc.dart';
import 'package:grid_wars/feature/game/presentation/widgets/animated_button.dart';

class XAndO extends StatefulWidget {
  const XAndO({super.key});

  @override
  State<XAndO> createState() => _XAndOState();
}

class _XAndOState extends State<XAndO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocBuilder<XOBloc, XOState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    state.isGameOver
                        ? (state.winner == "Draw" ? "🤝 It's a Draw!" : "🎉 Player ${state.winner} Wins!")
                        : "🔥 Turn: ${state.currentPlayer.name}",
                    key: ValueKey(state.isGameOver),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: state.isGameOver
                          ? (state.winner == "Draw" ? Colors.amber : Colors.greenAccent)
                          : state.currentPlayer.color,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final item = state.board[index];
                      final isWinCell = state.winningLine.contains(index);

                      return AnimatedButton(
                        onTap: () {
                          context.read<XOBloc>().add(TabEvent(index: index));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isWinCell ? Colors.greenAccent : AppColors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                offset: const Offset(3, 3),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: AppColors.white.withValues(alpha: 0.05),
                                offset: const Offset(-3, -3),
                                blurRadius: 6,
                              ),
                            ],
                          ),

                          child: Center(
                            child: AnimatedScale(
                              scale: item.icon.isEmpty ? 0 : 1,
                              duration: const Duration(milliseconds: 200),
                              child: item.icon.isEmpty
                                  ? const SizedBox()
                                  : SvgPicture.asset(
                                      item.icon,
                                      width: 48,
                                      height: 48,
                                      colorFilter: ColorFilter.mode(item.color, BlendMode.srcIn),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          context.read<XOBloc>().add(ResetGameEvent());
        },
        child: Container(
          height: 48,
          margin: EdgeInsetsGeometry.fromLTRB(16, 0, 16, context.padding.bottom + 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.cyanAccent.withValues(alpha: 0.5), Colors.blueAccent.withValues(alpha: 0.5)],
            ),
            boxShadow: [
              BoxShadow(color: AppColors.black.withValues(alpha: 0.3), offset: const Offset(3, 3), blurRadius: 6),
            ],
            border: Border.all(color: AppColors.white.withValues(alpha: 0.4), width: 1.2),
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: AppColors.white),
                SizedBox(width: 8),
                Text(
                  'Reset Game',
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
