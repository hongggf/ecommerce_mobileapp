import 'package:get/get.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final double price;
  final int variantId;
  final String? size;
  final String? color;
  final RxInt quantity;
  final RxBool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.variantId,
    this.size,
    this.color,
    int? quantity,
    bool isSelected = false,
  })  : quantity = (quantity ?? 1).obs,
        isSelected = isSelected.obs;

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'variant_id': variantId,
      'quantity': quantity.value,
      'size': size,
      'color': color,
    };
  }

  // Factory constructor from JSON response
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      name: json['product_name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      variantId: json['variant_id'] ?? 0,
      size: json['size'],
      color: json['color'],
      quantity: json['quantity'] ?? 1,
    );
  }

  // Create a copy with modifications
  CartItem copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? variantId,
    String? size,
    String? color,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      variantId: variantId ?? this.variantId,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity.value,
      isSelected: isSelected ?? this.isSelected.value,
    );
  }
}
