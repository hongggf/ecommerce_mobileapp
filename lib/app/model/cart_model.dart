import 'package:ecommerce_urban/app/model/cart_item_model.dart';

class Cart {
  final int id;
  final int userId;
  final String status;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.status,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    int cartId = 0;
    
    // Parse ID - handle different formats
    if (json['id'] != null) {
      if (json['id'] is String) {
        cartId = int.tryParse(json['id']) ?? 0;
      } else {
        cartId = (json['id'] as num).toInt();
      }
    }

    print('📦 [Cart Model] Parsing cart. ID from JSON: ${json['id']}, Parsed as: $cartId');

    if (cartId <= 0) {
      throw Exception('Invalid cart ID received: ${json['id']}');
    }

    // Parse userId - can be string or int
    int userId = 0;
    if (json['user_id'] != null) {
      if (json['user_id'] is String) {
        // If it's a UUID string, just use 0 for now
        userId = 0;
      } else {
        userId = (json['user_id'] as num).toInt();
      }
    }

    return Cart(
      id: cartId,
      userId: userId,
      status: json['status'] ?? 'active',
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}