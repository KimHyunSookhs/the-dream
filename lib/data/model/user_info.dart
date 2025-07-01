class UserInfo {
  final String? username;
  final String? name;

  UserInfo({this.username, this.name});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(username: json['username'], name: json['name']);
  }
}
