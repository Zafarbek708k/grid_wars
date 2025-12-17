import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    on<LoadLanguageEvent>((event, emit) {});
    on<ChangeLanguageEvent>((event, emit) {});
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
}
