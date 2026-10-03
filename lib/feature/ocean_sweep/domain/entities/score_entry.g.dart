// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreEntry _$ScoreEntryFromJson(Map<String, dynamic> json) => ScoreEntry(
  nickname: json['nickname'] as String,
  score: (json['score'] as num).toInt(),
  playedAt: DateTime.parse(json['playedAt'] as String),
);

Map<String, dynamic> _$ScoreEntryToJson(ScoreEntry instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'score': instance.score,
      'playedAt': instance.playedAt.toIso8601String(),
    };
