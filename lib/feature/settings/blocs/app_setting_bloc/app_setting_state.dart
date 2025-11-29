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

  @override
  List<Object?> get props => [selectedTheme, themeStatus, themeEnum, languageEnum, locale];
}

enum ThemeEnum {
  light(name: "", icon: ""),
  dark(name: "", icon: ""),
  system(name: "", icon: "");

  final String name;
  final String icon;

  const ThemeEnum({required this.name, required this.icon});
}

enum LanguageEnum {
  uzbek(name: "Uzbek", languageCode: "uz", countryCode: "UZ", locale: const Locale("uz", "UZ")),
  russian(name: "Russian", languageCode: "ru", countryCode: "RU", locale: Locale("ru", "RU")),
  english(name: "English", languageCode: "en", countryCode: "EN", locale: Locale("en", "EN"));

  final String name;
  final String languageCode;
  final String countryCode;
  final Locale locale;

  const LanguageEnum({required this.name, required this.languageCode, required this.countryCode, required this.locale});
}
