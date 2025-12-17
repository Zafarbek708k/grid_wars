import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';

enum ThemeEnum {
  light(mode: ThemeMode.light, title: LocaleKeys.light, icon: ""),
  dark(mode: ThemeMode.dark, title: LocaleKeys.dark, icon: ""),
  system(mode: ThemeMode.system, title: LocaleKeys.system, icon: "");

  final String title;
  final String icon;
  final ThemeMode mode;

  const ThemeEnum({required this.title, required this.icon, this.mode = ThemeMode.system});

  static ThemeEnum fromString(String code) {
    return ThemeEnum.values.firstWhere((element) => element.title == code, orElse: () => ThemeEnum.system);
  }
}
