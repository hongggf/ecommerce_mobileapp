class AddressModel {
  final String id;
  final String title;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? title,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress => '$address, $city, $state $zipCode';
}