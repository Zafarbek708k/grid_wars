import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/game_accent_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/game_item_type_enum.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/core/widgets/buttons/clay_button.dart';
import 'package:grid_wars/feature/x_and_o/presentation/blocs/x_and_o_bloc/x_o_bloc.dart';

class XAndO extends StatefulWidget {
  const XAndO({super.key});

  @override
  State<XAndO> createState() => _XAndOState();
}

class _XAndOState extends State<XAndO> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Game Hub',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
          color: gameAccentColor(HomeScreenApps.ticTacToe),
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
            final bool botIsO = state.mode == GameMode.bot;
            String playerLabel(GameItemTypeEnum player) => (botIsO && player.isO) ? 'BOT' : player.name;
            String winnerLabel() => (botIsO && state.winner == GameItemTypeEnum.o.name) ? 'BOT' : (state.winner ?? '');

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: GameMode.values.map((mode) {
                    final bool isSelected = state.mode == mode;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AnimatedButton(
                        onTap: () => context.read<XOBloc>().add(SelectMode$XOEvent(mode: mode)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.cyanAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? Colors.cyanAccent : Colors.white24, width: 1.5),
                          ),
                          child: Text(
                            mode == GameMode.friend ? 'PLAY WITH FRIEND' : 'PLAY VS BOT',
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
                if (state.mode == GameMode.bot) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: BotDifficulty.values.map((difficulty) {
                      final bool isSelected = state.botDifficulty == difficulty;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedButton(
                          onTap: () => context.read<XOBloc>().add(SelectDifficulty$XOEvent(difficulty: difficulty)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amberAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isSelected ? Colors.amberAccent : Colors.white24, width: 1.2),
                            ),
                            child: Text(
                              difficulty.label,
                              style: TextStyle(
                                color: isSelected ? Colors.amberAccent : Colors.white70,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    state.isGameOver
                        ? (state.winner == "Draw" ? "🤝 It's a Draw!" : "🎉 ${winnerLabel()} Wins!")
                        : (state.isBotTurn ? "🤖 Bot is thinking..." : "🔥 Turn: ${playerLabel(state.currentPlayer)}"),
                    key: ValueKey('${state.isGameOver}-${state.isBotTurn}'),
                    style: TextStyle(
                      fontSize: 28,
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
                        isDisabled: state.isBotTurn,
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
                              BoxShadow(color: Colors.black.withValues(alpha: 0.4), offset: const Offset(3, 3), blurRadius: 6),
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
      floatingActionButton: ClayResetButton(
        onTap: () => context.read<XOBloc>().add(ResetGameEvent()),
        label: LocaleKeys.resetGame.tr(),
        color: gameAccentColor(HomeScreenApps.ticTacToe),
      ),
    );
  }
}
