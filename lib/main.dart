import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/core/widgets/app_scope.dart';
import 'package:grid_wars/core/widgets/grid_wars_game.dart';
import 'package:grid_wars/firebase_options.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await StorageRepository.getInstance();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    runApp(GridWarsAppScope(child: GridWarsGame(analytics: analytics)));
  }, (error, path) => debugPrint("Error: $error\nPath: $path\n\n"));
}
