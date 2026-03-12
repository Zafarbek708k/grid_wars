import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GridWarsAppScope extends StatefulWidget {
  const GridWarsAppScope({super.key, required this.child});

  final Widget child;

  @override
  State<GridWarsAppScope> createState() => GridWarsAppScopeState();
}

class GridWarsAppScopeState extends State<GridWarsAppScope> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: widget.child,
    );
  }
}
