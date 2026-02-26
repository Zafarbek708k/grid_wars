part of 'app_setting_bloc.dart';

sealed class AppSettingEvent extends Equatable {
  const AppSettingEvent();
}

class LoadThemeEvent extends AppSettingEvent {
  const LoadThemeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeThemeEvent extends AppSettingEvent {
  final ThemeEnum themeEnum;

  const ChangeThemeEvent(this.themeEnum);

  @override
  List<Object?> get props => [themeEnum];
}

class LoadLanguageEvent extends AppSettingEvent {
  const LoadLanguageEvent();

  @override
  List<Object?> get props => [];
}

class ChangeLanguageEvent extends AppSettingEvent {
  final LanguageEnum languageEnum;

  const ChangeLanguageEvent(this.languageEnum);

  @override
  List<Object?> get props => [languageEnum];
}
