import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'score_entry.g.dart';

/// One leaderboard row. `playedAt` round-trips through JSON as an ISO-8601
/// string (json_serializable's default `DateTime` handling).
@JsonSerializable()
class ScoreEntry extends Equatable {
  const ScoreEntry({
    required this.nickname,
    required this.score,
    required this.playedAt,
  });

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => _$ScoreEntryFromJson(json);

  final String nickname;
  final int score;
  final DateTime playedAt;

  Map<String, dynamic> toJson() => _$ScoreEntryToJson(this);

  @override
  List<Object?> get props => [nickname, score, playedAt];
}
