import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grid_wars/core/theme/dark.dart';
import 'package:grid_wars/core/theme/light.dart';
import 'package:grid_wars/feature/init/presentation/pages/splash.dart';

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
    return MaterialApp(
      title: 'Grid Wars',
      debugShowCheckedModeBanner: kDebugMode,
      darkTheme: Dark.theme(),
      themeMode: ThemeMode.light,
      theme: Light.theme(),
      home: const Splash(),
    );
  }
}
