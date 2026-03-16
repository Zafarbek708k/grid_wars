import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/game/presentation/blocs/memory_match_bloc/memory_match_bloc.dart';
import 'package:grid_wars/feature/game/presentation/pages/memory_match.dart';
import 'package:grid_wars/feature/game/presentation/blocs/mental_bloc/mental_bloc.dart';
import 'package:grid_wars/feature/game/presentation/pages/mental.dart';
import 'package:grid_wars/feature/game/presentation/blocs/x_and_o_bloc/x_o_bloc.dart';
import 'package:grid_wars/feature/game/presentation/pages/x_and_o.dart';

class AppRouter {
  static const String xAndO = '/x_and_o';
  static const String memoryMatch = '/memory_match';
  static const String mental = '/mental';

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
