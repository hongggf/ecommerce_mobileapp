class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? roles;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle roles - support both formats
    List<String>? rolesList;
    
    if (json['roles'] != null && json['roles'] is List) {
      rolesList = [];
      for (var role in json['roles']) {
        if (role is String) {
          // Format: ["Admin", "Manager"]
          rolesList.add(role);
        } else if (role is Map<String, dynamic> && role.containsKey('name')) {
          // Format: [{"id": "1", "name": "Admin"}, ...]
          rolesList.add(role['name'] ?? '');
        }
      }
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      roles: rolesList ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'status': status,
    };
  }
}