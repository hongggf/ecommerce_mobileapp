class UserProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String avatar;
  final Creator? creator;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.avatar,
    this.creator,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      avatar: json['avatar'] ?? '',
      creator:
      json['creator'] != null ? Creator.fromJson(json['creator']) : null,
    );
  }
}

class Creator {
  final int id;
  final String name;
  final String email;

  Creator({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}