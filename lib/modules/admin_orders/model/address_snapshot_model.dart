class AddressSnapshot {
  final String recipientName;
  final String line1;
  final String? line2;
  final String city;
  final String? state;
  final String? postalCode;
  final String countryCode;

  AddressSnapshot({
    required this.recipientName,
    required this.line1,
    this.line2,
    required this.city,
    this.state,
    this.postalCode,
    required this.countryCode,
  });

  factory AddressSnapshot.fromJson(Map<String, dynamic> json) {
    return AddressSnapshot(
      recipientName: json['recipient_name'] ?? '',
      line1: json['line1'] ?? '',
      line2: json['line2'],
      city: json['city'] ?? '',
      state: json['state'],
      postalCode: json['postal_code'],
      countryCode: json['country_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient_name': recipientName,
      'line1': line1,
      if (line2 != null) 'line2': line2,
      'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postal_code': postalCode,
      'country_code': countryCode,
    };
  }

  String get fullAddress {
    final parts = [line1, if (line2 != null) line2, city, state, countryCode];
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }
}