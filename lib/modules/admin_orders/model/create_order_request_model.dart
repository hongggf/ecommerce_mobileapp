
import 'package:ecommerce_urban/modules/admin_orders/model/address_snapshot_model.dart';

class CreateOrderRequest {
  final int cartId;
  final AddressSnapshot shippingAddress;
  final AddressSnapshot billingAddress;
  final String? notes;
  final double discountTotal;
  final double taxTotal;
  final double shippingTotal;

  CreateOrderRequest({
    required this.cartId,
    required this.shippingAddress,
    required this.billingAddress,
    this.notes,
    required this.discountTotal,
    required this.taxTotal,
    required this.shippingTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'shipping_address': shippingAddress.toJson(),
      'billing_address': billingAddress.toJson(),
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'discount_total': discountTotal,
      'tax_total': taxTotal,
      'shipping_total': shippingTotal,
    };
  }
}