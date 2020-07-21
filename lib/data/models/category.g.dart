// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionCategory _$QuestionCategoryFromJson(Map<String, dynamic> json) {
  return QuestionCategory(
    id: json['id'] as String,
    title: json['title'] as String,
    shortTitle: json['shortTitle'] as String,
    description: json['description'] as String,
    questions:
        (json['questions'] as List)?.map((e) => e as String)?.toList() ?? [],
    questionDescriptions: (json['questionDescriptions'] as List)
            ?.map((e) => e as String)
            ?.toList() ??
        [],
    type: intToType(json['type'] as int),
  );
}

Map<String, dynamic> _$QuestionCategoryToJson(QuestionCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shortTitle': instance.shortTitle,
      'description': instance.description,
      'questions': instance.questions,
      'questionDescriptions': instance.questionDescriptions,
      'type': typeToInt(instance.type),
    };
