// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionInfoModel _$VersionInfoModelFromJson(Map<String, dynamic> json) =>
    VersionInfoModel(
      lastVersion: json['last_version'] as String? ?? '',
      message: json['message'] as String? ?? '',
      minRequiredVersion: json['min_required_version'] as String? ?? '',
      title: json['title'] as String? ?? '',
      updateType: json['update_type'] as String? ?? '',
    );

Map<String, dynamic> _$VersionInfoModelToJson(VersionInfoModel instance) =>
    <String, dynamic>{
      'last_version': instance.lastVersion,
      'update_type': instance.updateType,
      'min_required_version': instance.minRequiredVersion,
      'title': instance.title,
      'message': instance.message,
    };
