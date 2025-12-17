import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color whiteToDark;
  final Color darkToWhite;
  final Color whiteToCyan;

  const AppThemeExtension({required this.whiteToDark, required this.darkToWhite, required this.whiteToCyan});

  @override
  ThemeExtension<AppThemeExtension> copyWith({Color? whiteToDark, Color? darkToWhite, Color? whiteToCyan}) {
    return AppThemeExtension(
      whiteToCyan: whiteToCyan ?? this.whiteToCyan,
      whiteToDark: whiteToDark ?? this.whiteToDark,
      darkToWhite: darkToWhite ?? this.darkToWhite,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(covariant ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      whiteToCyan: Color.lerp(whiteToCyan, other.whiteToCyan, t) ?? whiteToCyan,
      whiteToDark: Color.lerp(whiteToDark, other.whiteToDark, t) ?? whiteToDark,
      darkToWhite: Color.lerp(darkToWhite, other.darkToWhite, t) ?? darkToWhite,
    );
  }

  static const light = AppThemeExtension(
    whiteToDark: AppColors.white,
    darkToWhite: AppColors.black,
    whiteToCyan: AppColors.white,
  );
  static const dark = AppThemeExtension(
    whiteToDark: AppColors.black,
    darkToWhite: AppColors.white,
    whiteToCyan: AppColors.cyan,
  );
}
