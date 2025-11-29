import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grid_wars/core/theme/dark.dart';
import 'package:grid_wars/core/theme/light.dart';
import 'package:grid_wars/feature/game/presentation/blocs/x_o_bloc.dart';
import 'package:grid_wars/feature/game/presentation/pages/x_and_o.dart';
import 'package:grid_wars/feature/init/pages/splash.dart';
import 'package:grid_wars/feature/settings/blocs/app_setting_bloc/app_setting_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, path) {
      debugPrint("Error: $error\nPath: $path\n\n");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppSettingBloc()),
        BlocProvider(create: (context) => XOBloc()),
      ],
      child: BlocBuilder<AppSettingBloc, AppSettingState>(
        buildWhen: (o, n) {
          final locale = n.locale != o.locale;
          final theme = n.selectedTheme != o.selectedTheme;
          return locale || theme;
        },
        builder: (context, state) {
          return MaterialApp(
            title: 'Grid Wars',
            debugShowCheckedModeBanner: kDebugMode,
            darkTheme: Dark.theme(),
            theme: Light.theme(),
            themeMode: state.selectedTheme,
            home: const Splash(),
          );
        },
      ),
    );
  }
}
