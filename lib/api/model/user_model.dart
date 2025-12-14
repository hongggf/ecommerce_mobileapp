class UserModel {
  bool? success;
  String? message;
  List<UserData>? data;

  UserModel({this.success, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      if (json['data'] is List) {
        // When API returns a list of users
        data = (json['data'] as List)
            .map((e) => UserData.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['data'] is Map) {
        // When API returns a single user object
        data = [UserData.fromJson(json['data'] as Map<String, dynamic>)];
      }
    }
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.map((v) => v.toJson()).toList(),
  };
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  int? createdBy;
  Creator? creator;
  String? createdAt;
  String? updatedAt;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.createdBy,
    this.creator,
    this.createdAt,
    this.updatedAt,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    createdBy = json['created_by'];
    creator =
    json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'created_by': createdBy,
    'creator': creator?.toJson(),
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class Creator {
  int? id;
  String? name;
  String? email;

  Creator({this.id, this.name, this.email});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}