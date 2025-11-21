import 'dart:ui';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_icons.dart';

enum PopUpStatus {
  success(icon: AppIcons.success, color: AppColors.green),
  warning(icon: AppIcons.warning, color: AppColors.orange),
  error(icon: AppIcons.error, color: AppColors.red),
  gift(icon: AppIcons.gift, color: AppColors.cyan);

  final String icon;
  final Color color;

  const PopUpStatus({required this.icon, required this.color});

  bool get isSuccess => this == PopUpStatus.success;

  bool get isWarning => this == PopUpStatus.warning;

  bool get isError => this == PopUpStatus.error;

  static PopUpStatus fromString(String value) {
    return PopUpStatus.values.firstWhere((elem) => elem.name == value, orElse: () => PopUpStatus.warning);
  }
}
