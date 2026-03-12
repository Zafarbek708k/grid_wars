import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/feature/game/memory_match/presentation/blocs/memory_match_bloc.dart';
import 'package:grid_wars/feature/game/memory_match/presentation/pages/memory_match.dart';
import 'package:grid_wars/feature/game/x_and_o/presentation/blocs/x_o_bloc.dart';
import 'package:grid_wars/feature/game/x_and_o/presentation/pages/x_and_o.dart';

class AppRouter {
  static const String xAndO = '/x_and_o';
  static const String memoryMatch = '/memory_match';

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
