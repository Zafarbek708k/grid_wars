part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final AppVersionEntity appVersion;

  const AppConfigState({this.appVersion = const AppVersionEntity()});

  AppConfigState copyWith({AppVersionEntity? appVersion}) {
    return AppConfigState(appVersion: appVersion ?? this.appVersion);
  }

  @override
  List<Object?> get props => [appVersion];
}
