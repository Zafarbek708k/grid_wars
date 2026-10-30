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
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_rules.dart';
import 'package:grid_wars/feature/chess/presentation/blocs/chess_bloc/chess_bloc.dart';

const Map<PieceType, String> _whiteGlyphs = {
  PieceType.king: '♔',
  PieceType.queen: '♕',
  PieceType.rook: '♖',
  PieceType.bishop: '♗',
  PieceType.knight: '♘',
  PieceType.pawn: '♙',
};
const Map<PieceType, String> _blackGlyphs = {
  PieceType.king: '♚',
  PieceType.queen: '♛',
  PieceType.rook: '♜',
  PieceType.bishop: '♝',
  PieceType.knight: '♞',
  PieceType.pawn: '♟',
};

String _glyphFor(ChessPiece piece) => (piece.color == PieceColor.white ? _whiteGlyphs : _blackGlyphs)[piece.type]!;

class Chess extends StatelessWidget {
  const Chess({super.key});

  @override
  Widget build(BuildContext context) {
    final Color accent = gameAccentColor(HomeScreenApps.chess);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Chess',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: ClayIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.of(context).pop(), color: accent),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<ChessBloc, ChessState>(
            listenWhen: (previous, current) => !previous.isGameOver && current.isGameOver,
            listener: (context, state) {
              final bloc = context.read<ChessBloc>();
              final String title = state.isCheckmate
                  ? (state.winner == PieceColor.white ? 'WHITE WINS' : 'BLACK WINS')
                  : 'STALEMATE';
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(value: bloc, child: _ResultDialog(title: title)),
              );
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: GameMode.values.map((mode) {
                        final bool isSelected = state.mode == mode;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: AnimatedButton(
                            onTap: () => context.read<ChessBloc>().add(SelectMode$ChessEvent(mode: mode)),
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
                              onTap: () => context.read<ChessBloc>().add(SelectDifficulty$ChessEvent(difficulty: difficulty)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? accent.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: isSelected ? accent : Colors.white24),
                                ),
                                child: Text(
                                  difficulty.label,
                                  style: TextStyle(
                                    color: isSelected ? accent : Colors.white70,
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
                    const SizedBox(height: 10),
                    _StatusBar(state: state),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AspectRatio(aspectRatio: 1, child: _ChessBoard(state: state)),
                    ),
                    const SizedBox(height: 110),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClayResetButton(
        onTap: () => context.read<ChessBloc>().add(const ResetGame$ChessEvent()),
        label: LocaleKeys.resetGame.tr(),
        color: accent,
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.state});

  final ChessState state;

  @override
  Widget build(BuildContext context) {
    final bool botIsBlack = state.mode == GameMode.bot;
    String label() {
      if (state.turn == PieceColor.white) return 'WHITE TO MOVE';
      return botIsBlack ? 'BOT THINKING…' : 'BLACK TO MOVE';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        state.isCheck ? '${label()} — CHECK!' : label(),
        style: TextStyle(color: state.isCheck ? Colors.redAccent : Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}

class _ChessBoard extends StatelessWidget {
  const _ChessBoard({required this.state});

  final ChessState state;

  @override
  Widget build(BuildContext context) {
    final Set<(int, int)> legalTargets = {for (final m in state.legalMoves) (m.toRow, m.toCol)};
    final (int, int)? checkedKing = state.isCheck ? ChessRules.findKing(state.board, state.turn) : null;

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
      clipBehavior: Clip.antiAlias,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 64,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          final int row = index ~/ 8;
          final int col = index % 8;
          final piece = state.board[row][col];
          final bool isDark = (row + col).isOdd;
          final bool isSelected = state.selected == (row, col);
          final bool isLegalTarget = legalTargets.contains((row, col));
          final move = state.lastMove;
          final bool isLastMoveSquare =
              move != null && ((move.fromRow == row && move.fromCol == col) || (move.toRow == row && move.toCol == col));
          final bool isCheckedKingSquare = checkedKing == (row, col);

          Color bg = isDark ? const Color(0xFF4E342E) : const Color(0xFFEFEBE0);
          if (isCheckedKingSquare) {
            bg = const Color(0xFFD32F2F);
          } else if (isSelected) {
            bg = const Color(0xFF64B5F6);
          } else if (isLastMoveSquare) {
            bg = Color.alphaBlend(const Color(0x552196F3), bg);
          }

          return GestureDetector(
            onTap: () => context.read<ChessBloc>().add(SelectSquare$ChessEvent(row: row, col: col)),
            child: Container(
              color: bg,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (piece != null)
                    Text(
                      _glyphFor(piece),
                      style: TextStyle(fontSize: 26, color: piece.color == PieceColor.white ? Colors.white : Colors.black87),
                    ),
                  if (isLegalTarget && piece == null)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  if (isLegalTarget && piece != null)
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.redAccent, width: 2.5)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog({required this.title});

  final String title;

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
              Text(title, style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClayButton(
                    compact: true,
                    icon: Icons.replay_rounded,
                    color: gameAccentColor(HomeScreenApps.chess),
                    label: LocaleKeys.playAgain.tr(),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<ChessBloc>().add(const ResetGame$ChessEvent());
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
