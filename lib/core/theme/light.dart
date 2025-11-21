import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/theme/theme_extension.dart';

abstract class Light {
  static ThemeData theme() => ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    extensions: [AppThemeExtension.light],
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
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
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black,
  );

  static const displayMedium = TextStyle(
    fontSize: 22,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.black,
  );

  static const displaySmall = TextStyle(
    fontSize: 21,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.black,
  );

  static const headlineLarge = TextStyle(
    fontSize: 20,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black,
  );

  static const headlineMedium = TextStyle(
    fontSize: 19,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.black,
  );

  static const headlineSmall = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.black,
  );

  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.black,
  );

  static const bodyMedium = TextStyle(
    fontSize: 17,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.black,
  );

  static const bodySmall = TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.black,
  );

  static const labelLarge = TextStyle(
    fontSize: 15,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black,
  );

  static const labelMedium = TextStyle(
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.black,
  );

  static const labelSmall = TextStyle(
    fontSize: 13,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.black,
  );

  static const titleLarge = TextStyle(
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.black,
  );

  static const titleMedium = TextStyle(
    fontSize: 13,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.black,
  );

  static const titleSmall = TextStyle(
    fontSize: 12,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.black,
  );
}
