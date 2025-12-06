// // class AuthModel {
// //   String? email;
// //   String? password;
// //   String? fullName;
// //   String? phone;
// //   String? token;

// //   AuthModel({
// //     this.email,
// //     this.password,
// //     this.fullName,
// //     this.phone,
// //     this.token,
// //   });

// //   AuthModel.fromJson(Map<String, dynamic> json) {
// //     email = json['email'];
// //     password = json['password'];
// //     fullName = json['full_name'];
// //     phone = json['phone'];
// //     token = json['token'] ?? json['access_token'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['email'] = email;
// //     data['password'] = password;
// //     data['full_name'] = fullName;
// //     data['phone'] = phone;
// //     data['token'] = token;
// //     return data;
// //   }
// // }
// class AuthModel {
//   String? userId;
//   String? email;
//   String? fullName;
//   String? password;
//   String? phone;
//   String? token;

//   AuthModel({
//     this.userId,
//     this.email,
//     this.fullName,
//     this.password,
//     this.phone,
//     this.token,
//   });

//   factory AuthModel.fromJson(Map<String, dynamic> json) {
//     // Your login API likely returns user object inside "user"
//     final user = json['user'] ?? json;

//     return AuthModel(
//       userId: user['id']?.toString(),       // UUID or int → always string
//       email: user['email'],
//       fullName: user['full_name'],
//       password: user['password'],
//       phone: user['phone'],
//       token: json['token'] ?? json['access_token'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'email': email,
//       'fullName': fullName,
//       'password': password,
//       'phone': phone,
//       'token': token,
//     };
//   }
// }
class AuthModel {
  String? userId;
  String? email;
  String? fullName;
  String? password;
  String? phone;
  String? token;
  String? role;  // 🔥 Added role field

  AuthModel({
    this.userId,
    this.email,
    this.fullName,
    this.password,
    this.phone,
    this.token,
    this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    // Your login API returns user object inside "user"
    final user = json['user'] ?? json;

    return AuthModel(
      userId: user['id']?.toString(),
      email: user['email'],
      fullName: user['full_name'],
      password: user['password'],
      phone: user['phone'],
      token: json['token'] ?? json['access_token'],
      role: user['role_status'] ?? user['role'],  // 🔥 Handle both "role_status" and "role"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'fullName': fullName,
      'password': password,
      'phone': phone,
      'token': token,
      'role': role,  // 🔥 Include role
    };
  }
}