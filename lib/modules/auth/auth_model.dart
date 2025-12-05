class AuthModel {
  String? email;
  String? password;
  String? fullName;
  String? phone;
  String? token;

  AuthModel({
    this.email,
    this.password,
    this.fullName,
    this.phone,
    this.token,
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fullName = json['full_name'];
    phone = json['phone'];
    token = json['token'] ?? json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['token'] = token;
    return data;
  }
}
