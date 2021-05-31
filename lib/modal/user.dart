import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  User(
    this.name,
    this.email,
  );
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'],
      json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': email,
    };
  }
}
