import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/router/app_router.dart';
import 'package:grid_wars/core/theme/dark.dart';
import 'package:grid_wars/core/theme/light.dart';
import 'package:grid_wars/feature/init/pages/splash.dart';
import 'package:grid_wars/feature/navigation/presentation/blocs/navigator_cubit.dart';
import 'package:grid_wars/feature/settings/presentation/blocs/app_config_bloc/app_config_bloc.dart';
import 'package:grid_wars/feature/settings/presentation/blocs/app_setting_bloc/app_setting_bloc.dart';

class GridWarsGame extends StatelessWidget {
  const GridWarsGame({super.key, required this.analytics});

  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavigationBarCubit()),
        BlocProvider(
          create: (context) => AppSettingBloc()
            ..add(const LoadThemeEvent())
            ..add(LoadLanguageEvent()),
        ),
        BlocProvider(create: (context) => AppConfigBloc()),
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
            onGenerateRoute: AppRouter.onGenerateRoute,
            darkTheme: Dark.theme(),
            theme: Light.theme(),
            navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            // themeMode: state.selectedTheme,
            themeMode: ThemeMode.dark,
            home: const Splash(),
          );
        },
      ),
    );
  }
}
