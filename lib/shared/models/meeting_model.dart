import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_model.freezed.dart';
part 'meeting_model.g.dart';

@freezed
class MeetingModel with _$MeetingModel {
  const factory MeetingModel({
    required String id,
    required String title,
    DateTime? startTime,
    DateTime? endTime,
    String? audioUrl,
    String? transcript,
    String? summary,
    List<String>? keyPoints,
    List<String>? actionItems,
    List<Map<String, dynamic>>? deadlines,
    List<String>? attendees,
    @Default('pending') String status,
    DateTime? createdAt,
  }) = _MeetingModel;

  factory MeetingModel.fromJson(Map<String, dynamic> json) =>
      _$MeetingModelFromJson(json);
}