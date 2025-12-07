import 'package:ecommerce_urban/modules/admin_orders/model/address_snapshot_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';

class OrderModel {
  final int? id;
  final String orderNumber;
  final String userId;
  final String status;
  final String financialStatus;
  final AddressSnapshot shippingAddressSnapshot;
  final AddressSnapshot billingAddressSnapshot;
  final String subtotal;
  final String discountTotal;
  final String taxTotal;
  final String shippingTotal;
  final String grandTotal;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.financialStatus,
    required this.shippingAddressSnapshot,
    required this.billingAddressSnapshot,
    required this.subtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.shippingTotal,
    required this.grandTotal,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  /// SAFELY PARSE DATE
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      financialStatus: json['financial_status']?.toString() ?? 'pending',

      shippingAddressSnapshot:
          AddressSnapshot.fromJson(json['shipping_address_snapshot'] ?? {}),

      billingAddressSnapshot:
          AddressSnapshot.fromJson(json['billing_address_snapshot'] ?? {}),

      subtotal: json['subtotal']?.toString() ?? '0',
      discountTotal: json['discount_total']?.toString() ?? '0',
      taxTotal: json['tax_total']?.toString() ?? '0',
      shippingTotal: json['shipping_total']?.toString() ?? '0',
      grandTotal: json['grand_total']?.toString() ?? '0',

      notes: json['notes']?.toString(),

      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),

      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_number': orderNumber,
      'user_id': userId,
      'status': status,
      'financial_status': financialStatus,
      'shipping_address_snapshot': shippingAddressSnapshot.toJson(),
      'billing_address_snapshot': billingAddressSnapshot.toJson(),
      'subtotal': subtotal,
      'discount_total': discountTotal,
      'tax_total': taxTotal,
      'shipping_total': shippingTotal,
      'grand_total': grandTotal,
      if (notes != null) 'notes': notes,
    };
  }

  /// Convert numeric string → double
  double get subtotalDouble => double.tryParse(subtotal) ?? 0.0;
  double get discountDouble => double.tryParse(discountTotal) ?? 0.0;
  double get taxDouble => double.tryParse(taxTotal) ?? 0.0;
  double get shippingDouble => double.tryParse(shippingTotal) ?? 0.0;
  double get grandTotalDouble => double.tryParse(grandTotal) ?? 0.0;

  /// -----------------------------------------
  ///             COPY WITH SUPPORT
  /// -----------------------------------------
  OrderModel copyWith({
    String? status,
    String? financialStatus,
    String? notes,
    DateTime? updatedAt,
    List<OrderItem>? items,
  }) {
    return OrderModel(
      id: id,
      orderNumber: orderNumber,
      userId: userId,
      status: status ?? this.status,
      financialStatus: financialStatus ?? this.financialStatus,
      shippingAddressSnapshot: shippingAddressSnapshot,
      billingAddressSnapshot: billingAddressSnapshot,
      subtotal: subtotal,
      discountTotal: discountTotal,
      taxTotal: taxTotal,
      shippingTotal: shippingTotal,
      grandTotal: grandTotal,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }
}
