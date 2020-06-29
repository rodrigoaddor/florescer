import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  final String name;
  final String email;
  final String city;
  final String state;

  UserData({this.id, this.name, this.email, this.city, this.state});

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  bool get isRegistered => [name, email, city, state].every((element) => element != null);
}
