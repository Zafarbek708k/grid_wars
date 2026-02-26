import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/custom_appbar.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key, required this.title, this.appBarActions = const [], required this.body});

  final String title;
  final List<Widget> appBarActions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C5364),
      appBar: CustomAppBar(title: title, actions: appBarActions),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364), Color(0xFF203A43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(45 * pi / 1.1),
          ),
        ),
        child: SizedBox(width: double.infinity, height: double.infinity, child: body),
      ),
    );
  }
}
