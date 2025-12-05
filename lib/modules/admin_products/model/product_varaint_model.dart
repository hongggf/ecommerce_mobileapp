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
      sku: json['sku'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      status: json['status'] ?? 'active',
      assets: (json['assets'] as List?)
          ?.map((a) => ProductAsset.fromJson(a))
          .toList(),
    );
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
}