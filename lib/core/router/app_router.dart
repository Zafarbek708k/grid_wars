import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/game_2048/presentation/blocs/game2048_bloc/game2048_bloc.dart';
import 'package:grid_wars/feature/game_2048/presentation/pages/game_2048.dart';
import 'package:grid_wars/feature/mental/presentation/blocs/mental_bloc/mental_bloc.dart';
import 'package:grid_wars/feature/mental/presentation/pages/mental.dart';
import 'package:grid_wars/feature/minesweeper/presentation/blocs/minesweeper_bloc/minesweeper_bloc.dart';
import 'package:grid_wars/feature/minesweeper/presentation/pages/minesweeper.dart';
import 'package:grid_wars/feature/nard/presentation/blocs/nard_bloc/nard_bloc.dart';
import 'package:grid_wars/feature/nard/presentation/pages/nard.dart';
import 'package:grid_wars/feature/ocean_sweep/presentation/pages/ocean_sweep_page.dart';
import 'package:grid_wars/feature/hangman/presentation/blocs/hangman_bloc/hangman_bloc.dart';
import 'package:grid_wars/feature/hangman/presentation/pages/hangman.dart';
import 'package:grid_wars/feature/bubble_shooter/presentation/blocs/bubble_shooter_cubit/bubble_shooter_cubit.dart';
import 'package:grid_wars/feature/bubble_shooter/presentation/pages/bubble_shooter_page.dart';
import 'package:grid_wars/feature/chess/presentation/blocs/chess_bloc/chess_bloc.dart';
import 'package:grid_wars/feature/chess/presentation/pages/chess.dart';
import 'package:grid_wars/feature/puzzle15/presentation/blocs/puzzle15_bloc/puzzle15_bloc.dart';
import 'package:grid_wars/feature/snake/presentation/blocs/snake_cubit/snake_cubit.dart';
import 'package:grid_wars/feature/snake/presentation/pages/snake_page.dart';
import 'package:grid_wars/feature/tetris/presentation/blocs/tetris_cubit/tetris_cubit.dart';
import 'package:grid_wars/feature/tetris/presentation/pages/tetris_page.dart';
import 'package:grid_wars/feature/puzzle15/presentation/pages/puzzle15.dart';
import 'package:grid_wars/feature/sudoku/presentation/blocs/sudoku_bloc/sudoku_bloc.dart';
import 'package:grid_wars/feature/sudoku/presentation/pages/sudoku.dart';
import 'package:grid_wars/feature/word_search/presentation/blocs/word_search_bloc/word_search_bloc.dart';
import 'package:grid_wars/feature/word_search/presentation/pages/word_search.dart';
import 'package:grid_wars/feature/x_and_o/presentation/blocs/x_and_o_bloc/x_o_bloc.dart';
import 'package:grid_wars/feature/x_and_o/presentation/pages/x_and_o.dart';
import 'package:grid_wars/feature/platformer/presentation/pages/platformer_home_screen.dart';

class AppRouter {
  static const String xAndO = '/x_and_o';
  static const String mental = '/mental';
  static const String platformer = '/platformer';
  static const String puzzle15 = '/puzzle15';
  static const String sudoku = '/sudoku';
  static const String nard = '/nard';
  static const String game2048 = '/game2048';
  static const String minesweeper = '/minesweeper';
  static const String wordSearch = '/word_search';
  static const String oceanSweep = '/ocean_sweep';
  static const String snake = '/snake';
  static const String hangman = '/hangman';
  static const String tetris = '/tetris';
  static const String bubbleShooter = '/bubble_shooter';
  static const String chess = '/chess';

  static Route<Object?> onGenerateRoute(RouteSettings setting) {
    return switch (setting.name) {
      xAndO => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return XOBloc();
          },
          child: const XAndO(),
        ),
        settings: RouteSettings(name: AppRouter.xAndO),
      ),
      mental => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return MentalBloc();
          },
          child: const Mental(),
        ),
        settings: RouteSettings(name: AppRouter.mental),
      ),
      platformer => MaterialPageRoute(
        builder: (context) => const PlatformerHomeScreen(),
        settings: RouteSettings(name: AppRouter.platformer),
      ),
      puzzle15 => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return Puzzle15Bloc();
          },
          child: const Puzzle15(),
        ),
        settings: RouteSettings(name: AppRouter.puzzle15),
      ),
      sudoku => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return SudokuBloc();
          },
          child: const Sudoku(),
        ),
        settings: RouteSettings(name: AppRouter.sudoku),
      ),
      nard => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return NardBloc();
          },
          child: const Nard(),
        ),
        settings: RouteSettings(name: AppRouter.nard),
      ),
      game2048 => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return Game2048Bloc();
          },
          child: const Game2048(),
        ),
        settings: RouteSettings(name: AppRouter.game2048),
      ),
      minesweeper => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return MinesweeperBloc();
          },
          child: const Minesweeper(),
        ),
        settings: RouteSettings(name: AppRouter.minesweeper),
      ),
      wordSearch => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return WordSearchBloc();
          },
          child: const WordSearch(),
        ),
        settings: RouteSettings(name: AppRouter.wordSearch),
      ),
      oceanSweep => MaterialPageRoute(
        builder: (context) => const OceanSweepPage(),
        settings: RouteSettings(name: AppRouter.oceanSweep),
      ),
      snake => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return SnakeCubit();
          },
          child: const SnakePage(),
        ),
        settings: RouteSettings(name: AppRouter.snake),
      ),
      hangman => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return HangmanBloc();
          },
          child: const Hangman(),
        ),
        settings: RouteSettings(name: AppRouter.hangman),
      ),
      tetris => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return TetrisCubit();
          },
          child: const TetrisPage(),
        ),
        settings: RouteSettings(name: AppRouter.tetris),
      ),
      bubbleShooter => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return BubbleShooterCubit();
          },
          child: const BubbleShooterPage(),
        ),
        settings: RouteSettings(name: AppRouter.bubbleShooter),
      ),
      chess => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return ChessBloc();
          },
          child: const Chess(),
        ),
        settings: RouteSettings(name: AppRouter.chess),
      ),
      _ => MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text("Error Screen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
              centerTitle: true,
            ),
          );
        },
      ),
    };
  }
}
