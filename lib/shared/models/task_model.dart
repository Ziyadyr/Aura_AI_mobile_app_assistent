import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    DateTime? dueDate,
    @Default('medium') String priority,
    @Default('general') String category,
    @Default('pending') String status,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? completedAt,
    String? aiSuggestion,
    @Default(false) bool isAiGenerated,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}