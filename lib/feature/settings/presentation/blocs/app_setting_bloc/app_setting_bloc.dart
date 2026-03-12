import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:grid_wars/core/constants/storage_keys.dart';
import 'package:grid_wars/core/enums/language_enum.dart';
import 'package:grid_wars/core/enums/theme_enum.dart';
import 'package:grid_wars/core/service/storage_service.dart';

part 'app_setting_event.dart';

part 'app_setting_state.dart';

class AppSettingBloc extends Bloc<AppSettingEvent, AppSettingState> {
  AppSettingBloc() : super(const AppSettingState()) {
    on<AppSettingEvent>((event, emit) {});
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_changeTheme);
    on<LoadLanguageEvent>(_onLoadLanguage);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  FutureOr<void> _onLoadTheme(LoadThemeEvent event, Emitter<AppSettingState> emit) async {
    final String theme = StorageRepository.getString(StorageKeys.selectedTheme);
    final savedTheme = ThemeEnum.fromString(theme);

    emit(state.copyWith(selectedTheme: savedTheme.mode));
  }

  FutureOr<void> _changeTheme(ChangeThemeEvent event, Emitter<AppSettingState> emit) async {
    await StorageRepository.putString(StorageKeys.selectedTheme, event.themeEnum.title);
    emit(state.copyWith(selectedTheme: event.themeEnum.mode, themeEnum: event.themeEnum));
  }

  FutureOr<void> _onLoadLanguage(LoadLanguageEvent event, Emitter<AppSettingState> emit) async {
    final String language = StorageRepository.getString(StorageKeys.selectedLanguage);
    final savedLanguage = LanguageEnum.fromString(language);

    log("Loaded language: $language, Saved language enum: $savedLanguage");
    emit(state.copyWith(languageEnum: savedLanguage, locale: savedLanguage.languageCode));
  }

  FutureOr<void> _onChangeLanguage(ChangeLanguageEvent event, Emitter<AppSettingState> emit) async {
    await StorageRepository.putString(StorageKeys.selectedLanguage, event.languageEnum.languageCode);
    emit(state.copyWith(languageEnum: event.languageEnum, locale: event.languageEnum.languageCode));

    final val = StorageRepository.getString(StorageKeys.selectedLanguage);
    log("Stored language in storage: $val");
  }
}
