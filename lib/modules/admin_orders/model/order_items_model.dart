class OrderItem {
  final int? id;
  final int orderId;
  final int productId;
  final int? variantId;
  final int quantity;
  final String unitPrice;
  final Map<String, dynamic>? taxes;
  final Map<String, dynamic>? discounts;
  final String? productName;
  final String? variantName;
  final String? imageUrl;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.unitPrice,
    this.taxes,
    this.discounts,
    this.productName,
    this.variantName,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variantId: json['variant_id'],
      quantity: json['quantity'] ?? 1,
      unitPrice: json['unit_price']?.toString() ?? '0',
      taxes: json['taxes'],
      discounts: json['discounts'],
      productName: json['product_name'],
      variantName: json['variant_name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      'quantity': quantity,
      'unit_price': unitPrice,
      if (taxes != null) 'taxes': taxes,
      if (discounts != null) 'discounts': discounts,
    };
  }

  double get unitPriceDouble => double.tryParse(unitPrice) ?? 0.0;
  double get totalPrice => unitPriceDouble * quantity;
}
