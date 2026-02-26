import 'dart:ui';

enum LanguageEnum {
  uzbek(name: "Uzbek", languageCode: "uz", countryCode: "UZ", locale: const Locale("uz", "UZ")),
  russian(name: "Russian", languageCode: "ru", countryCode: "RU", locale: Locale("ru", "RU")),
  english(name: "English", languageCode: "en", countryCode: "EN", locale: Locale("en", "EN"));

  final String name;
  final String languageCode;
  final String countryCode;
  final Locale locale;

  const LanguageEnum({required this.name, required this.languageCode, required this.countryCode, required this.locale});

  static LanguageEnum fromString(String code) {
    return LanguageEnum.values.firstWhere((element) => element.languageCode == code, orElse: () => LanguageEnum.uzbek);
  }
}
