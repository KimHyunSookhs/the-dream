class User {
  final String? username;
  final String? password;
  final String? name;
  final String? confirmPassword;

  const User({
    required this.username,
    required this.password,
    required this.name,
    required this.confirmPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      confirmPassword: json['confirmPassword'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'name': name,
    'confirmPassword': confirmPassword,
  };
}
