import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/feature/home/presentation/pages/game_screen.dart';
import 'package:grid_wars/feature/home/presentation/pages/home_screen.dart';
import 'package:grid_wars/feature/profile/presentation/pages/profile_screen.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

enum NavBarEnum {
  home(title: LocaleKeys.home, icon: AppIcons.home),
  games(title: LocaleKeys.games, icon: AppIcons.game),
  profile(title: LocaleKeys.profile, icon: AppIcons.userCircle);

  const NavBarEnum({required this.icon, this.title = ""});

  final String icon;
  final String title;

  bool get isMenu => this == NavBarEnum.home;

  bool get isOrder => this == NavBarEnum.games;

  bool get isSetting => this == NavBarEnum.profile;

  static NavBarEnum fromString(String value) {
    return NavBarEnum.values.firstWhere((element) => element.name == value, orElse: () => NavBarEnum.home);
  }
}

class TabNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final NavBarEnum tabItem;

  const TabNavigator({required this.tabItem, required this.navigatorKey, super.key});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        final routeBuilders = _routeBuilders(context: context, routeSettings: routeSettings);
        return MaterialPageRoute(
          builder: (context) =>
          routeBuilders.containsKey(routeSettings.name) ? routeBuilders[routeSettings.name]!(context) : Container(),
        );
      },
    );
  }

  Map<String, WidgetBuilder> _routeBuilders({required BuildContext context, required RouteSettings routeSettings}) {
    switch (widget.tabItem) {
      case NavBarEnum.home:
        return {TabNavigatorRoutes.root: (context) => HomeScreen()};
      case NavBarEnum.games:
        return {TabNavigatorRoutes.root: (context) => GameScreen()};
      case NavBarEnum.profile:
        return {TabNavigatorRoutes.root: (context) => ProfileScreen()};
    }
  }

  @override
  bool get wantKeepAlive => true;
}
