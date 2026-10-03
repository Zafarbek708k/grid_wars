import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/enums/language_enum.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key, required this.language, required this.isSelected, required this.onTap});

  final LanguageEnum language;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.cyan.withValues(alpha: 0.75), AppColors.cyan.withValues(alpha: 0.4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Color.fromRGBO(30, 52, 72, 0.9), Color.fromRGBO(22, 42, 60, 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: Border.all(color: Colors.white.withValues(alpha: isSelected ? 0.4 : 0.15), width: 1.2),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(3, 5)),
                  BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(-2, -2)),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(language.name, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.white)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
