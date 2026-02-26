part of 'app_setting_bloc.dart';

class AppSettingState extends Equatable {
  final ThemeMode selectedTheme;
  final FormzSubmissionStatus themeStatus;
  final ThemeEnum themeEnum;
  final LanguageEnum languageEnum;
  final String locale;

  const AppSettingState({
    this.themeStatus = FormzSubmissionStatus.initial,
    this.selectedTheme = ThemeMode.light,
    this.themeEnum = ThemeEnum.light,
    this.languageEnum = LanguageEnum.uzbek,
    this.locale = 'uz',
  });

  AppSettingState copyWith({
    ThemeMode? selectedTheme,
    FormzSubmissionStatus? themeStatus,
    ThemeEnum? themeEnum,
    LanguageEnum? languageEnum,
    String? locale,
  }) {
    return AppSettingState(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      themeStatus: themeStatus ?? this.themeStatus,
      themeEnum: themeEnum ?? this.themeEnum,
      languageEnum: languageEnum ?? this.languageEnum,
      locale: locale ?? this.locale,
    );
  }


  @override
  List<Object?> get props => [selectedTheme, themeStatus, themeEnum, languageEnum, locale];
}
