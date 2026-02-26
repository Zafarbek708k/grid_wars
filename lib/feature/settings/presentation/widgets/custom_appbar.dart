import 'package:flutter/material.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.centerTitle = false,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
  });

  final String title;
  final List<Widget> actions;
  final bool centerTitle;
  final double elevation;
  final double scrolledUnderElevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: context.themeExtension.whiteToCyan, width: 1)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        child: AppBar(
          elevation: elevation,
          scrolledUnderElevation: scrolledUnderElevation,
          centerTitle: centerTitle,
          backgroundColor: const Color.fromRGBO(12, 43, 62, 1),
          title: Text(title, style: context.textTheme.bodyMedium),
          actions: [...actions, const SizedBox(width: 12)],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
