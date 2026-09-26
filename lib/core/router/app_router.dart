import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/game_2048/presentation/blocs/game2048_bloc/game2048_bloc.dart';
import 'package:grid_wars/feature/game_2048/presentation/pages/game_2048.dart';
import 'package:grid_wars/feature/memory_match/presentation/blocs/memory_match_bloc/memory_match_bloc.dart';
import 'package:grid_wars/feature/memory_match/presentation/pages/memory_match.dart';
import 'package:grid_wars/feature/mental/presentation/blocs/mental_bloc/mental_bloc.dart';
import 'package:grid_wars/feature/mental/presentation/pages/mental.dart';
import 'package:grid_wars/feature/minesweeper/presentation/blocs/minesweeper_bloc/minesweeper_bloc.dart';
import 'package:grid_wars/feature/minesweeper/presentation/pages/minesweeper.dart';
import 'package:grid_wars/feature/nard/presentation/blocs/nard_bloc/nard_bloc.dart';
import 'package:grid_wars/feature/nard/presentation/pages/nard.dart';
import 'package:grid_wars/feature/puzzle15/presentation/blocs/puzzle15_bloc/puzzle15_bloc.dart';
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
  static const String memoryMatch = '/memory_match';
  static const String mental = '/mental';
  static const String platformer = '/platformer';
  static const String puzzle15 = '/puzzle15';
  static const String sudoku = '/sudoku';
  static const String nard = '/nard';
  static const String game2048 = '/game2048';
  static const String minesweeper = '/minesweeper';
  static const String wordSearch = '/word_search';

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
      memoryMatch => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            return MemoryMatchBloc();
          },
          child: const MemoryMatch(),
        ),
        settings: RouteSettings(name: AppRouter.memoryMatch),
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
