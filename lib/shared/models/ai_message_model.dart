import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_message_model.freezed.dart';
part 'ai_message_model.g.dart';

@freezed
class AiMessageModel with _$AiMessageModel {
  const factory AiMessageModel({
    required String id,
    required String content,
    required String role,
    DateTime? timestamp,
    String? actionType,
    Map<String, dynamic>? metadata,
    List<Map<String, dynamic>>? suggestedActions,
    @Default(false) bool isProcessing,
  }) = _AiMessageModel;

  factory AiMessageModel.fromJson(Map<String, dynamic> json) =>
      _$AiMessageModelFromJson(json);
}