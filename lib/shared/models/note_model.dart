import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
class NoteModel with _$NoteModel {
  const factory NoteModel({
    required String id,
    required String title,
    required String content,
    @Default('plain') String type,
    List<String>? tags,
    @Default('general') String category,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? aiSummary,
    List<String>? extractedTasks,
    List<String>? extractedEvents,
    List<DateTime>? extractedDeadlines,
    @Default(false) bool isFavorite,
    @Default(false) bool isAiGenerated,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}