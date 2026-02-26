import 'package:equatable/equatable.dart';
import 'package:grid_wars/feature/settings/data/models/version_info_model.dart';
import 'package:json_annotation/json_annotation.dart';

class VersionInfoEntity extends Equatable {
  final String lastVersion;
  final String updateType;
  final String minRequiredVersion;
  final String title;
  final String message;

  const VersionInfoEntity({
    this.lastVersion = '',
    this.updateType = '',
    this.minRequiredVersion = '',
    this.title = '',
    this.message = '',
  });

  @override
  List<Object?> get props => [lastVersion, updateType, minRequiredVersion, title, message];
}

class VersionInfoConvertor implements JsonConverter<VersionInfoEntity, Map<String, dynamic>> {
  const VersionInfoConvertor();

  @override
  VersionInfoEntity fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return VersionInfoModel.fromJson(json);
    }

    return VersionInfoEntity(
      lastVersion: json['last_version'] as String? ?? '',
      updateType: json['update_type'] as String? ?? '',
      minRequiredVersion: json['min_required_version'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson(VersionInfoEntity object) {
    return {
      'last_version': object.lastVersion,
      'update_type': object.updateType,
      'min_required_version': object.minRequiredVersion,
      'title': object.title,
      'message': object.message,
    };
  }
}
