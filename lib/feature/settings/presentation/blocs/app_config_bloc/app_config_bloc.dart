import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:grid_wars/core/constants/firebase_remote_config_keys.dart';
import 'package:grid_wars/core/service/remote_config_service.dart';
import 'package:grid_wars/feature/settings/data/models/app_version_model.dart';
import 'package:grid_wars/feature/settings/domain/entities/app_version_entity.dart';

part 'app_config_event.dart';

part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final remoteConfig = FirebaseRemoteConfig.instance;

  AppConfigBloc() : super(const AppConfigState()) {
    setupRemoteConfig();
    on<AppConfigEvent>((event, emit) {});
    on<RemoteConfigUpdateEvent>(_updateEvent);
    on<InitializeConfigEvent>(_initialize);
  }

  FutureOr<void> setupRemoteConfig() async {
    log("Remote config setupRemoteConfig called");
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      add(RemoteConfigUpdateEvent(updatedKeys: event.updatedKeys));
    });
  }

  FutureOr<void> _updateEvent(RemoteConfigUpdateEvent event, Emitter<AppConfigState> emit) async {
    log("Remote config _updateEvent called");
    final updatedKeys = event.updatedKeys;

    if (updatedKeys == null || updatedKeys.isEmpty) {
      return;
    }

    final fetchers = {"app_version": () => _decodeJson(remoteConfig.getString("app_version"))};

    final updatedValues = <String, dynamic>{};

    for (var key in updatedKeys) {
      if (fetchers.containsKey(key)) {
        updatedValues[key] = fetchers[key]!();
      }
    }

    if (updatedValues.isEmpty) {
      log("No relevant keys updated.");
      return;
    }

    emit(
      state.copyWith(
        appVersion: updatedValues["app_version"] != null
            ? AppVersionModel.fromJson(updatedValues["app_version"])
            : null,
      ),
    );

    log("********************************");
    log("Updated Remote Config Values:");
    updatedValues.forEach((key, value) {
      log("$key: $value");
    });
    log("********************************");
  }

  FutureOr<void> _initialize(InitializeConfigEvent event, Emitter<AppConfigState> emit) async {
    log("Remote Config _initialize called");
    await RemoteConfigService.setupRemoteConfig();
    await RemoteConfigService.fetchRemoteConfig();

    add(
      RemoteConfigUpdateEvent(
        updatedKeys: {...FirebaseRemoteConfigKeys.booleanKeys, ...FirebaseRemoteConfigKeys.jsonKeys},
      ),
    );
  }

  Map<String, dynamic>? _decodeJson(String jsonString) {
    if (jsonString.isEmpty) return null;
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      log("Failed to decode JSON: $e");
      return null;
    }
  }
}
