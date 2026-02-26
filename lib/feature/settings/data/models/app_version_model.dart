import 'package:grid_wars/feature/settings/domain/entities/app_version_entity.dart';
import 'package:grid_wars/feature/settings/domain/entities/version_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_version_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AppVersionModel extends AppVersionEntity {
  const AppVersionModel({super.android, super.ios});

  factory AppVersionModel.fromJson(Map<String, dynamic> json) => _$AppVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionModelToJson(this);
}
