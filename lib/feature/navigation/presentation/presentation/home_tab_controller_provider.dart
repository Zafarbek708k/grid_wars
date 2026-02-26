import 'package:flutter/material.dart';

class HomeTabControllerProvider extends InheritedWidget {
  final TabController controller;

  const HomeTabControllerProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  static HomeTabControllerProvider of(BuildContext context) {
    final HomeTabControllerProvider? result = context.dependOnInheritedWidgetOfExactType<HomeTabControllerProvider>();
    assert(result != null, 'No HomeTabControllerProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(HomeTabControllerProvider oldWidget) => false;
}
