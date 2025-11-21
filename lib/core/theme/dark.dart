import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/theme/theme_extension.dart';

abstract class Dark {
  const Dark();

  static ThemeData theme() => ThemeData(
    fontFamily: "Exo",
    extensions: [AppThemeExtension.dark],
    textTheme: TextTheme(
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
    ),
  );

  static const displayLarge = TextStyle(
    fontSize: 32,
    fontFamily: 'Exo',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.white,
  );

  static const displayMedium = TextStyle(
    fontSize: 22,
    fontFamily: 'Exo',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.white,
  );

  static const displaySmall = TextStyle(
    fontSize: 21,
    fontFamily: 'Exo',
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.white,
  );

  static const headlineLarge = TextStyle(
    fontSize: 20,
    fontFamily: 'Exo',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.white,
  );

  static const headlineMedium = TextStyle(
    fontSize: 19,
    fontFamily: 'Exo',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.white,
  );

  static const headlineSmall = TextStyle(
    fontSize: 18,
    fontFamily: 'Exo',
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.white,
  );

  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontFamily: 'Exo',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.white,
  );

  static const bodyMedium = TextStyle(
    fontSize: 17,
    fontFamily: 'Exo',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.white,
  );

  static const bodySmall = TextStyle(
    fontSize: 16,
    fontFamily: 'Exo',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.white,
  );

  static const labelLarge = TextStyle(
    fontSize: 15,
    fontFamily: 'Exo',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.white,
  );

  static const labelMedium = TextStyle(
    fontSize: 14,
    fontFamily: 'Exo',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.white,
  );

  static const labelSmall = TextStyle(
    fontSize: 13,
    fontFamily: 'Exo',
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.white,
  );

  static const titleLarge = TextStyle(
    fontSize: 14,
    fontFamily: 'Exo',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.white,
  );

  static const titleMedium = TextStyle(
    fontSize: 13,
    fontFamily: 'Exo',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.white,
  );

  static const titleSmall = TextStyle(
    fontSize: 12,
    fontFamily: 'Exo',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.white,
  );
}
