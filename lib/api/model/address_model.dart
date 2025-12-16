class AddressModel {
  int? id;
  int? userId;
  String fullName;
  String phone;
  String province;
  String district;
  String street;
  bool isDefault;

  AddressModel({
    this.id,
    this.userId,
    required this.fullName,
    required this.phone,
    required this.province,
    required this.district,
    required this.street,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json['id'],
    userId: json['user_id'],
    fullName: json['full_name'],
    phone: json['phone'],
    province: json['province'],
    district: json['district'],
    street: json['street'],
    isDefault: json['is_default'] == 1 || json['is_default'] == true,
  );

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'phone': phone,
    'province': province,
    'district': district,
    'street': street,
    'is_default': isDefault,
  };
}