// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionModel _$AppVersionModelFromJson(Map<String, dynamic> json) =>
    AppVersionModel(
      android: json['android'] == null
          ? const VersionInfoEntity()
          : const VersionInfoConvertor().fromJson(
              json['android'] as Map<String, dynamic>,
            ),
      ios: json['ios'] == null
          ? const VersionInfoEntity()
          : const VersionInfoConvertor().fromJson(
              json['ios'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AppVersionModelToJson(AppVersionModel instance) =>
    <String, dynamic>{
      'ios': const VersionInfoConvertor().toJson(instance.ios),
      'android': const VersionInfoConvertor().toJson(instance.android),
    };
