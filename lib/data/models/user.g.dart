// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    answers: (json['answers'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as int)?.toList()),
        ) ??
        {},
    satisfaction: json['satisfaction'] as int,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'city': instance.city,
      'state': instance.state,
      'answers': instance.answers,
      'satisfaction': instance.satisfaction,
    };
