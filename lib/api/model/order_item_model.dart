// class OrderItemModel {
//   int? id;
//   int? orderId;
//   int? productId;
//   String? productName;
//   double? price;
//   int? quantity;
//   double? subtotal;
//   String? createdAt;

//   OrderItemModel({
//     this.id,
//     this.orderId,
//     this.productId,
//     this.productName,
//     this.price,
//     this.quantity,
//     this.subtotal,
//     this.createdAt,
//   });

//   factory OrderItemModel.fromJson(Map<String, dynamic> json) {
//     return OrderItemModel(
//       id: json['id'],
//       orderId: json['order_id'],
//       productId: json['product']?['id'],
//       productName: json['product']?['name'],
//       price: (json['product']?['price'] ?? 0).toDouble(),
//       quantity: json['quantity'],
//       subtotal: (json['subtotal'] ?? 0).toDouble(),
//       createdAt: json['created_at'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'order_id': orderId,
//     'product_id': productId,
//     'quantity': quantity,
//   };
// }
class OrderItemModel {
  int? id;
  int? orderId;
  int? productId;
  String? productName;
  double? price;
  int? quantity;
  double? subtotal;
  String? createdAt;

  OrderItemModel({
    this.id,
    this.orderId,
    this.productId,
    this.productName,
    this.price,
    this.quantity,
    this.subtotal,
    this.createdAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely convert to double
    double? _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          print('⚠️ Error parsing price "$value": $e');
          return 0.0;
        }
      }
      return 0.0;
    }

    // Helper to safely convert to int
    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          print('⚠️ Error parsing int "$value": $e');
          return null;
        }
      }
      return null;
    }

    // Your API returns:
    // {
    //   "id": 1,
    //   "order_id": 1,
    //   "product": {
    //     "id": 1,
    //     "name": "samsung1",
    //     "price": "1200.00"
    //   },
    //   "quantity": 1,
    //   "subtotal": 1200,
    //   "created_at": "2025-12-16 14:36:54"
    // }

    return OrderItemModel(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product']?['id']),
      productName: json['product']?['name'] as String?,
      price: _toDouble(json['product']?['price']),
      quantity: _toInt(json['quantity']),
      subtotal: _toDouble(json['subtotal']),
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'product_id': productId,
    'quantity': quantity,
  };

  @override
  String toString() {
    return 'OrderItemModel(id: $id, product: $productName, qty: $quantity, price: $price, subtotal: $subtotal)';
  }
}