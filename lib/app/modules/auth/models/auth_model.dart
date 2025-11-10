class AuthModel {
  final int id;
  final String username;
  final String email;
  final String token;

  AuthModel({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
