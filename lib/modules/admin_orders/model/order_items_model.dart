import 'package:ecommerce_urban/modules/admin_products/model/product_model.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int variantId;
  final int quantity;
  final double unitPrice;
  final Map<String, dynamic>? taxes;
  final Map<String, dynamic>? discounts;
  final String createdAt;
  final String updatedAt;
  final Product? product;
  final ProductVariant? variant;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    this.taxes,
    this.discounts,
    required this.createdAt,
    required this.updatedAt,
    this.product,
    this.variant,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product_id']),
      variantId: _toInt(json['variant_id']),
      quantity: _toInt(json['quantity']),
      unitPrice: _toDouble(json['unit_price']),
      taxes: json['taxes'],
      discounts: json['discounts'],
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      variant: json['variant'] != null ? ProductVariant.fromJson(json['variant']) : null,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  double get totalPrice => quantity * unitPrice;
  
  double get taxAmount {
    if (taxes == null) return 0.0;
    double total = 0.0;
    taxes!.forEach((key, value) {
      total += _toDouble(value);
    });
    return total;
  }
  
  double get discountAmount {
    if (discounts == null) return 0.0;
    double total = 0.0;
    discounts!.forEach((key, value) {
      total += _toDouble(value);
    });
    return total;
  }
}