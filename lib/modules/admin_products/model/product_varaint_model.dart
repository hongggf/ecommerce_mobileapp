import 'package:ecommerce_urban/modules/admin_products/model/product_asset.dart';

class ProductVariant {
  final int? id;
  final int? productId;
  final String sku;
  final String name;
  final double price;
  final String status;
  final List<ProductAsset>? assets;

  ProductVariant({
    this.id,
    this.productId,
    required this.sku,
    required this.name,
    required this.price,
    required this.status,
    this.assets,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      productId: json['product_id'],
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      price: _parsePrice(json['price']),
      status: json['status'] ?? 'active',
      assets: (json['assets'] as List?)
          ?.map((a) => ProductAsset.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Helper method to parse price from either String or num
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    
    if (price is String) {
      try {
        return double.parse(price);
      } catch (e) {
        print('⚠️ Error parsing price string "$price": $e');
        return 0.0;
      }
    }
    
    if (price is num) {
      return price.toDouble();
    }
    
    print('⚠️ Unknown price type: ${price.runtimeType}');
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'sku': sku,
      'name': name,
      'price': price,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'ProductVariant(id: $id, productId: $productId, name: $name, sku: $sku, price: $price, status: $status)';
  }
}