import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@freezed
class ReminderModel with _$ReminderModel {
  const factory ReminderModel({
    required String id,
    required String title,
    String? description,
    DateTime? dueDate,
    @Default('time') String triggerType,
    String? location,
    double? latitude,
    double? longitude,
    @Default(false) bool isRecurring,
    String? recurrenceRule,
    @Default('medium') String priority,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _ReminderModel;

  factory ReminderModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelFromJson(json);
}