class User {
  String name;
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
