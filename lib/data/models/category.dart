import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class QuestionCategory {
  final String id;
  final String title;
  final String shortTitle;
  final String description;
  @JsonKey(defaultValue: [])
  final List<String> questions;

  QuestionCategory({
    this.id,
    this.title,
    this.shortTitle,
    this.description,
    this.questions,
  });

  factory QuestionCategory.fromJson(Map<String, dynamic> json) => _$QuestionCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionCategoryToJson(this);
}
