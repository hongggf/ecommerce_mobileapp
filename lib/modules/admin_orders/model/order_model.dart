// import 'package:ecommerce_urban/modules/admin_orders/model/user_model.dart';

// class Order {
//   final int id;
//   final String orderNumber;
//   final int userId;
//   final String status;
//   final String financialStatus;
//   final Map<String, dynamic>? shippingAddressSnapshot;
//   final Map<String, dynamic>? billingAddressSnapshot;
//   final double subtotal;
//   final double discountTotal;
//   final double taxTotal;
//   final double shippingTotal;
//   final double grandTotal;
//   final String? notes;
//   final String createdAt;
//   final String updatedAt;
//   final User? user;

//   Order({
//     required this.id,
//     required this.orderNumber,
//     required this.userId,
//     required this.status,
//     required this.financialStatus,
//     this.shippingAddressSnapshot,
//     this.billingAddressSnapshot,
//     required this.subtotal,
//     required this.discountTotal,
//     required this.taxTotal,
//     required this.shippingTotal,
//     required this.grandTotal,
//     this.notes,
//     required this.createdAt,
//     required this.updatedAt,
//     this.user,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: _toInt(json['id']),
//       orderNumber: json['order_number']?.toString() ?? '',
//       userId: _toInt(json['user_id']),
//       status: json['status']?.toString() ?? 'pending',
//       financialStatus: json['financial_status']?.toString() ?? 'pending',
//       shippingAddressSnapshot: json['shipping_address_snapshot'],
//       billingAddressSnapshot: json['billing_address_snapshot'],
//       subtotal: _toDouble(json['subtotal']),
//       discountTotal: _toDouble(json['discount_total']),
//       taxTotal: _toDouble(json['tax_total']),
//       shippingTotal: _toDouble(json['shipping_total']),
//       grandTotal: _toDouble(json['grand_total']),
//       notes: json['notes']?.toString(),
//       createdAt: json['created_at']?.toString() ?? '',
//       updatedAt: json['updated_at']?.toString() ?? '',
//       user: json['user'] != null ? User.fromJson(json['user']) : null,
//     );
//   }

//   static int _toInt(dynamic value) {
//     if (value == null) return 0;
//     if (value is int) return value;
//     if (value is String) return int.tryParse(value) ?? 0;
//     if (value is double) return value.toInt();
//     return 0;
//   }

//   static double _toDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     return 0.0;
//   }
// }
import 'package:ecommerce_urban/modules/admin_orders/model/user_model.dart';

class Order {
  final int id;
  final String orderNumber;
  final String userId;
  final String status;
  final String financialStatus;
  final Map<String, dynamic>? shippingAddressSnapshot;
  final Map<String, dynamic>? billingAddressSnapshot;
  final double subtotal;
  final double discountTotal;
  final double taxTotal;
  final double shippingTotal;
  final double grandTotal;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final User? user;

  Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.financialStatus,
    this.shippingAddressSnapshot,
    this.billingAddressSnapshot,
    required this.subtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.shippingTotal,
    required this.grandTotal,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: _toInt(json['id']),
      orderNumber: json['order_number']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      financialStatus: json['financial_status']?.toString() ?? 'pending',
      shippingAddressSnapshot: json['shipping_address_snapshot'],
      billingAddressSnapshot: json['billing_address_snapshot'],
      subtotal: _toDouble(json['subtotal']),
      discountTotal: _toDouble(json['discount_total']),
      taxTotal: _toDouble(json['tax_total']),
      shippingTotal: _toDouble(json['shipping_total']),
      grandTotal: _toDouble(json['grand_total']),
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
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
}
