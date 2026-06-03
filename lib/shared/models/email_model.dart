import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_model.freezed.dart';
part 'email_model.g.dart';

@freezed
class EmailModel with _$EmailModel {
  const factory EmailModel({
    required String id,
    required String subject,
    required String sender,
    required String senderEmail,
    String? body,
    String? summary,
    @Default(false) bool isRead,
    @Default(false) bool isStarred,
    @Default(false) bool isImportant,
    DateTime? receivedAt,
    List<String>? labels,
    List<String>? attachments,
    String? threadId,
    DateTime? createdAt,
  }) = _EmailModel;

  factory EmailModel.fromJson(Map<String, dynamic> json) =>
      _$EmailModelFromJson(json);
}