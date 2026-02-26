import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/enums/language_enum.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/game/presentation/widgets/animated_button.dart';

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
          color: isSelected ? Color.fromRGBO(39, 77, 99, 1) : Color.fromRGBO(22, 42, 60, 0.8),
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(language.name, style: context.textTheme.bodyMedium),
            const Spacer(),
            if (isSelected) const Icon(Icons.check, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
