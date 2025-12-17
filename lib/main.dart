import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_wars/core/theme/dark.dart';
import 'package:grid_wars/core/theme/light.dart';
import 'package:grid_wars/feature/game/presentation/blocs/x_o_bloc.dart';
import 'package:grid_wars/feature/init/pages/splash.dart';
import 'package:grid_wars/feature/settings/blocs/app_setting_bloc/app_setting_bloc.dart';

import 'firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      runApp(MyApp(analytics: analytics));
    },
    (error, path) {
      debugPrint("Error: $error\nPath: $path\n\n");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.analytics});

  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppSettingBloc()..add(const LoadThemeEvent())),
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
            debugShowCheckedModeBanner: false,
            darkTheme: Dark.theme(),
            theme: Light.theme(),
            navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
            themeMode: state.selectedTheme,
            home: const Splash(),
          );
        },
      ),
    );
  }
}
