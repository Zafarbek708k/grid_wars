import 'package:grid_wars/feature/settings/domain/entities/version_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VersionInfoModel extends VersionInfoEntity {
  const VersionInfoModel({super.lastVersion, super.message, super.minRequiredVersion, super.title, super.updateType});


  factory VersionInfoModel.fromJson(Map<String, dynamic> json) => _$VersionInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VersionInfoModelToJson(this);
}
