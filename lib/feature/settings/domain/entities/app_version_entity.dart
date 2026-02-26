import 'package:equatable/equatable.dart';
import 'package:grid_wars/feature/settings/domain/entities/version_info_entity.dart';

class AppVersionEntity extends Equatable {
  @VersionInfoConvertor()
  final VersionInfoEntity ios;
  @VersionInfoConvertor()
  final VersionInfoEntity android;

  const AppVersionEntity({this.ios = const VersionInfoEntity(), this.android = const VersionInfoEntity()});

  @override
  List<Object?> get props => [ios, android];
}
