class User {
  final String name;
  final String password;
  final String email;

  User({
    this.name,
    this.password,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      password: json['password'],
      email: json['email'],
    );
  }
}
