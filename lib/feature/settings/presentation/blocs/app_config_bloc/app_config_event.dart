part of 'app_config_bloc.dart';

sealed class AppConfigEvent extends Equatable {
  const AppConfigEvent();
}

class RemoteConfigUpdateEvent extends AppConfigEvent {
  final Set<String>? updatedKeys;

  const RemoteConfigUpdateEvent({this.updatedKeys});

  @override
  List<Object?> get props => [updatedKeys ?? <String>{}];
}

class InitializeConfigEvent extends AppConfigEvent {
  @override
  List<Object?> get props => [];
}
