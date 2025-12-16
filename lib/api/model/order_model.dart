class OrderModel {
  int? id;
  double? subtotal;
  double? shippingFee;
  double? discount;
  double? totalAmount;
  String? status;
  String? paymentStatus;
  int? addressId;
  String? createdAt;

  OrderModel({
    this.id,
    this.subtotal,
    this.shippingFee,
    this.discount,
    this.totalAmount,
    this.status,
    this.paymentStatus,
    this.addressId,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      subtotal: (json['amounts']?['subtotal'] ?? 0).toDouble(),
      shippingFee: (json['amounts']?['shipping_fee'] ?? 0).toDouble(),
      discount: (json['amounts']?['discount'] ?? 0).toDouble(),
      totalAmount: (json['amounts']?['total_amount'] ?? 0).toDouble(),
      status: json['status']?['order'] ?? 'pending',
      paymentStatus: json['status']?['payment'] ?? 'unpaid',
      addressId: json['address_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'address_id': addressId,
    'subtotal': subtotal,
    'shipping_fee': shippingFee,
    'discount': discount,
  };
}