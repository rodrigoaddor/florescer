import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

enum CategoryType { Diagnosis, Satisfaction }

CategoryType intToType(int i) => i != null ? CategoryType.values[i] : null;
int typeToInt(CategoryType type) => type != null ? type.index : null;

@JsonSerializable()
class QuestionCategory {
  final String id;
  final String title;
  final String shortTitle;
  final String description;

  @JsonKey(defaultValue: [])
  final List<String> questions;

  @JsonKey(fromJson: intToType, toJson: typeToInt)
  final CategoryType type;

  QuestionCategory({
    this.id,
    this.title,
    this.shortTitle,
    this.description,
    this.questions,
    this.type,
  });

  factory QuestionCategory.fromJson(Map<String, dynamic> json) => _$QuestionCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionCategoryToJson(this);
}
