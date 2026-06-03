import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event_model.freezed.dart';
part 'calendar_event_model.g.dart';

@freezed
class CalendarEventModel with _$CalendarEventModel {
  const factory CalendarEventModel({
    required String id,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    @Default(false) bool isAllDay,
    String? recurrence,
    @Default('personal') String category,
    List<String>? attendees,
    @Default(true) bool remindersEnabled,
    List<int>? reminderMinutes,
    @Default('busy') String availability,
    String? meetingUrl,
    DateTime? createdAt,
    @Default(false) bool isAiGenerated,
    String? source,
  }) = _CalendarEventModel;

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventModelFromJson(json);
}