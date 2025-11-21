import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color whiteToDark;

  const AppThemeExtension({required this.whiteToDark});

  @override
  ThemeExtension<AppThemeExtension> copyWith({Color? whiteToDark}) {
    return AppThemeExtension(whiteToDark: whiteToDark ?? this.whiteToDark);
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(covariant ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(whiteToDark: Color.lerp(whiteToDark, other.whiteToDark, t) ?? whiteToDark);
  }

  static const light = AppThemeExtension(whiteToDark: AppColors.white);
  static const dark = AppThemeExtension(whiteToDark: AppColors.black);
}
